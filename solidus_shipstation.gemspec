# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'solidus_shipstation'
  s.version     = '2.0.1'
  s.summary     = 'Solidus/ShipStation Integration'
  s.description = 'Integrates ShipStation API with Solidus. Supports exporting shipments and importing tracking numbers'
  s.required_ruby_version = '>= 2.1.0'

  s.author    = 'Stephen Puiszis'
  s.email     = 'steve@tablexi.com'
  s.homepage  = 'https://github.com/stephen-puiszis/solidus_shipstation'

  # s.files       = `git ls-files`.split("\n")
  # s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'solidus_core', '>= 1.1', '< 3'

  s.add_development_dependency 'solidus_auth_devise'
  s.add_development_dependency 'capybara', '~> 2.2'
  s.add_development_dependency 'coffee-rails', '~> 4.1.1'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'timecop'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rspec-rails', '~> 3'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-xsd'
  s.add_development_dependency 'simplecov'
end
