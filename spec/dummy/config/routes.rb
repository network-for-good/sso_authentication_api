Rails.application.routes.draw do

  mount SsoAuthenticationApi::Engine => "/sso_authentication_api"

end
