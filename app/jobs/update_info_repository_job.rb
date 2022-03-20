# frozen_string_literal: true

class UpdateInfoRepositoryJob < ApplicationJob
  include Rails.application.routes.url_helpers

  queue_as :default

  def perform(repository)
    repository_api = ApplicationContainer[:repository_api]
    github_id = repository.github_id.to_i

    client = repository_api.client(repository.user.token)
    found_repo = repository_api.get_repository(client, github_id)

    repository.update(
      github_id: found_repo[:id],
      full_name: found_repo[:full_name],
      name: found_repo[:name],
      clone_url: found_repo[:clone_url],
      language: found_repo[:language].downcase
    )

    CheckRepositoryJob.perform_later(repository.checks.last)
    repository_api.create_hook(client, github_id, api_checks_url)
  end
end
