SsoAuthenticationApi::Engine.routes.draw do
  namespace :v1 do
    namespace :admins do
      resources :authentications, only: [:create]
    end
  end
end
