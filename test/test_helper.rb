# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

module ActionDispatch
  class IntegrationTest
    include AuthConcern

    def sign_in_as_user(user)
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:github] = nil

      params = {
        provider: 'github',
        uid: Faker::Internet.uuid,
        info: {
          email: user.email
        },
        credentials: {
          token: user.token
        }
      }

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(params)
      Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:github]

      get '/auth/:provider/callback'
    end
  end
end
