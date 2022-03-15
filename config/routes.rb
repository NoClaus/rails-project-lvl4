# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    post 'checks', to: 'checks#checks'
  end

  scope module: :web do
    root 'welcome#index'

    get '/auth/:provider/callback', to: 'auth#callback', as: :callback_auth, via: :all
    post '/auth/:provider', to: 'auth#request', as: :auth_request
    delete '/auth/logout', to: 'auth#logout', as: :auth_logout

    resources :repositories, only: %i[index show new create] do
      scope module: :repositories do
        resources :checks, only: %i[create show]
      end
    end
  end
end