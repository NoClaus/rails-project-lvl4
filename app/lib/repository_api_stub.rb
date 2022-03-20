# frozen_string_literal: true

def get_fixture_path(name)
  Rails.root.join("test/fixtures/files/#{name}")
end

class RepositoryApiStub
  def self.client(_token); end

  def self.get_repositories(_client)
    repos_path = get_fixture_path('repositories.json')
    JSON.parse(File.read(repos_path)).map(&:symbolize_keys)
  end

  def self.get_repository(_client, _github_id)
    repo_path = get_fixture_path('repository.json')
    JSON.parse(File.read(repo_path)).symbolize_keys
  end

  def self.get_repository_commits(_client, _github_id)
    commits_path = get_fixture_path('commits.json')
    JSON.parse(File.read(commits_path)).map(&:symbolize_keys)
  end

  def self.create_hook(_client, _github_id, _url); end
end
