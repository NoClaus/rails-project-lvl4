# frozen_string_literal: true

class RepositoryLoaderJob < ApplicationJob
  queue_as :default

  def perform(repository_id, check_id)
    repository = Repository.find(repository_id)
    github_id = repository.github_id

    client = Octokit::Client.new(access_token: repository.user.token, per_page: 200)
    found_repo = client.repos.find { |repo| repo.id == github_id }

    repository.update(
      github_id: found_repo[:id],
      repo_name: found_repo[:full_name],
      clone_url: found_repo[:clone_url],
      language: found_repo[:language].downcase
    )

    RepositoryCheckJob.perform_later(repository_id, check_id)
  end
end
