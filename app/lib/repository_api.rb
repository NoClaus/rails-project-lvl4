# frozen_string_literal: true

class RepositoryApi
  def self.client(token)
    Octokit::Client.new(access_token: token, per_page: 100)
  end

  def self.get_repositories(client)
    client.repos
  end

  def self.get_repository(client, github_id)
    client.repo(github_id)
  end

  def self.get_repository_commits(client, github_id)
    client.commits(github_id)
  end

  def self.create_hook(client, github_id, url)
    client.create_hook(
      github_id,
      'web',
      {
        url: url,
        content_type: 'json'
      },
      {
        events: ['push'],
        active: true
      }
    )
  end
end
