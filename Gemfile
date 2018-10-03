source 'http://rubygems.org'

branch = ENV.fetch('SOLIDUS_BRANCH', 'master')
gem "solidus", github: "solidusio/solidus", branch: branch
gem 'guard', require: false
gem 'guard-rspec', require: false
gem 'pry-rails', require: false
gem 'codeclimate-test-reporter', group: :test, require: nil

if branch == 'master' || branch >= "v2.0"
  gem "rails-controller-testing", group: :test
else
  gem "rails", '~> 4.2.7' # workaround for bundler resolution issue
  gem "rails_test_params_backport", group: :test
end

group :test do
  if branch < "v2.5"
    gem 'factory_bot', '4.10.0'
  else
    gem 'factory_bot', '> 4.10.0'
  end
end

if ENV['DB'] == 'mysql'
  gem 'mysql2', '~> 0.4.10'
else
  gem 'pg', '~> 0.21'
end

gemspec
