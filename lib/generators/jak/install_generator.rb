# frozen_string_literal: true

module Jak
  # Defines a set of custom Generators
  module Generators
    # Generates the Jak Configuration file
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

      desc <<~DESC
        Description:
            Copies all required files for Jak into the application.
      DESC

      # Copy the configuration file to a sane place
      def copy_config_file
        template 'jak_initializer_config.rb', 'config/initializers/jak_initializer.rb'
        template 'dsl_development.rb', 'config/dsl/dev.rb'
        template 'ability_config.rb', 'app/models/ability.rb'
        template 'mongoid.yml', 'config/mongoid.yml'
      end
    end
  end
end
