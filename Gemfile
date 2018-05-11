source "https://rubygems.org"

branch = ENV.fetch('SOLIDUS_BRANCH', 'master')
gem "solidus", github: "solidusio/solidus", branch: branch
gem "solidus_auth_devise"

gem 'pg', '~> 0.21'
gem 'mysql2', '~> 0.4.9'

group :test, :development do
  gem 'pry-rails'
end

gemspec
