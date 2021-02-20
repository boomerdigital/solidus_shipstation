# frozen_string_literal: true

require_relative 'lib/solidus_shipstation/version'

Gem::Specification.new do |spec|
  spec.name = 'solidus_shipstation'
  spec.version = SolidusShipstation::VERSION
  spec.authors = ['Stephen Puiszis']
  spec.email = 'steve@tablexi.com'

  spec.summary = 'Solidus/ShipStation Integration'
  spec.description = 'Integrates ShipStation API with Solidus. Supports exporting shipments and importing tracking numbers'
  spec.homepage = 'https://github.com/solidusio-contrib/solidus_shipstation'
  spec.license = 'BSD-3-Clause'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/solidusio-contrib/solidus_shipstation'
  spec.metadata['changelog_uri'] = 'https://github.com/solidusio-contrib/solidus_shipstation/blob/master/CHANGELOG.md'

  spec.required_ruby_version = Gem::Requirement.new('~> 2.5')

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  files = Dir.chdir(__dir__) { `git ls-files -z`.split("\x0") }

  spec.files = files.grep_v(%r{^(test|spec|features)/})
  spec.test_files = files.grep(%r{^(test|spec|features)/})
  spec.bindir = "exe"
  spec.executables = files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'httparty', '~> 0.18'
  spec.add_dependency 'solidus_core', ['>= 2.0.0', '< 4']
  spec.add_dependency 'solidus_support', '~> 0.5'

  spec.add_development_dependency 'rails-controller-testing'
  spec.add_development_dependency 'rspec-xsd'
  spec.add_development_dependency 'solidus_dev_support', '~> 2.4'
end
