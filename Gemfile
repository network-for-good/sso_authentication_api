# frozen_string_literal: true

source 'https://rubygems.org'

# Declare your gem's dependencies in sso_authentication_api.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Security floor: the gemspec's `rails ~> 7.2` permits 7.2.3, which carries
# CVE-2026-33195, CVE-2026-66066, CVE-2026-33174 (activestorage) and
# CVE-2026-33176 (activesupport). Floats within 7.2.x so future patches apply.
gem 'rails', '~> 7.2.3', '>= 7.2.3.2'

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

group :test, :development do
  gem 'token_decoder', git: 'https://github.com/network-for-good/token_decoder.git', branch: 'main'
end
# To use a debugger
# gem 'byebug', group: [:development, :test]
