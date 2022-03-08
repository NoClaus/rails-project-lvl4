Rails.application.routes.draw do
  scope module: :web do
    get '/auth/:provider/callback', to: 'auth#callback', as: :callback_auth, via: :all
    post '/auth/:provider', to: 'auth#request', as: :auth_request
    delete '/auth/logout', to: 'auth#logout', as: :auth_logout
  end
end
