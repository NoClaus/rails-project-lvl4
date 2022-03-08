Rails.application.routes.draw do
  scope module: :web do
    root 'welcome#index'

    get '/auth/:provider/callback', to: 'auth#callback', as: :callback_auth, via: :all
    post '/auth/:provider', to: 'auth#request', as: :auth_request
    delete '/auth/logout', to: 'auth#logout', as: :auth_logout

    resources :repositories
  end
end