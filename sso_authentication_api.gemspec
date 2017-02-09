$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "sso_authentication_api/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "sso_authentication_api"
  s.version     = SsoAuthenticationApi::VERSION
  s.authors     = ["Thomas Hoen"]
  s.email       = ["tom@givecorps.om"]
  s.homepage    = ""
  s.summary     = "Allows the NFG SSO server to poll for users and authenticate them."
  s.description = ""
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.2.0"
  s.add_dependency "jwt"
  s.add_dependency "responders"
  s.add_dependency "active_model_serializers"

  s.add_development_dependency "rspec-rails", '~> 3.4.0'
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "pry"
  s.add_development_dependency "pry-byebug"
end
