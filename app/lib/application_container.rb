# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :repository_api, -> { RepositoryApiStub }
  else
    register :repository_api, -> { RepositoryApi }
  end
end
