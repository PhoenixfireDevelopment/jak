# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'jak/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'jak'
  spec.version     = Jak::VERSION
  spec.authors     = ['Mark D Holmberg']
  spec.email       = ['mark.d.holmberg@gmail.com']
  spec.summary     = 'Dynamic CanCanCan permissions DSL.'
  spec.description = 'Dynamic database based permissions DSL which integrates with CanCanCan.'
  spec.license     = 'MIT'

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'cancancan', '~> 1.15'
  spec.add_dependency 'jbuilder', '~> 2.9.1'
  spec.add_dependency 'mongoid', '~> 7.0.4'
  spec.add_dependency 'rails', '~> 5.2.4.4'

  spec.add_development_dependency 'factory_bot_rails'
  spec.add_development_dependency 'mysql2'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rails-controller-testing'
  spec.add_development_dependency 'rspec-rails', '~> 3.8'
  spec.add_development_dependency 'rubocop', '~> 0.74.0'
  spec.add_development_dependency 'yard', '~> 0.9.20'
end
