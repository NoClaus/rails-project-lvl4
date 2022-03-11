# frozen_string_literal: true

class RepositoryCheckJob < ApplicationJob
  queue_as :default

  before_perform do
    @repo_path = 'tmp/repo'

    if Dir.exist?(@repo_path)
      FileUtils.remove_dir(@repo_path, true)
    end

    Dir.mkdir(@repo_path)
  end

  after_perform do
    FileUtils.remove_dir(@repo_path, true)
  end

  def perform(repository_id, check_id)
    repository = Repository.find(repository_id)
    check = RepositoryCheck.find(check_id)

    check.check!

    begin
      clone_command = "git clone #{repository.clone_url} #{@repo_path}"
      start_process(clone_command)

      actions = get_check_actions(repository.language.to_sym)

      start_process(actions[:remove_config_command])

      check_results, _exit_status = start_process(actions[:check_command])

      results = JSON.parse(check_results)

      error_count = actions[:get_error_count].call(results)
      parsed_results = actions[:parse_check_results].call(results)

      client = Octokit::Client.new(access_token: repository.user.token, per_page: 200)
      last_commit = client::commits(repository.github_id).first

      check.update(
        passed: error_count.zero?,
        error_count: error_count,
        result: JSON.generate(parsed_results),
        reference_url: last_commit['html_url'],
        reference_sha: last_commit['sha'][0, 8],
      )

      check.finish!
    rescue StandardError
      check.reject!
    end
  end

  private

  def start_process(command)
    Open3.popen3(command) { |_stdin, stdout, _stderr, wait_thr| [stdout.read, wait_thr.value] }
  end

  def get_check_actions(language)
    actions = {
      javascript: {
        remove_config_command: "find #{@repo_path} -name '.eslintrc*' -delete",
        check_command: "npx eslint #{@repo_path} -f json",
        parse_check_results: ->(results) { parse_eslint_results(results) },
        get_error_count: ->(results) { results.sum { |result| result['errorCount'] } }
      },
      ruby: {
        remove_config_command: ':',
        check_command: "bundle exec rubocop #{@repo_path} --format json",
        parse_check_results: ->(results) { parce_rubocop_result(results) },
        get_error_count: ->(results) { results['summary']['offense_count'] }
      }
    }

    actions[language]
  end

  def parse_eslint_message(message)
    {
      message: message['message'],
      rule: message['ruleId'],
      line_column: "#{message['line']}:#{message['column']}"
    }
  end

  def parse_eslint_results(results)
    results
      .filter { |result| result['errorCount'].positive? }
      .map do |result|
        {
          file_path: result['filePath'],
          messages: result['messages'].map { |message| parse_eslint_message(message) }
        }
      end
  end

  def parse_rubocop_offense(offense)
    {
      message: offense['message'],
      rule: offense['cop_name'],
      line_column: "#{offense['location']['line']}:#{offense['location']['column']}"
    }
  end

  def parce_rubocop_result(results)
    results['files']
      .filter { |file| file['offenses'].any? }
      .map do |file|
        {
          file_path: file['path'],
          messages: file['offenses'].map { |offense| parse_rubocop_offense(offense) }
        }
      end
  end
end