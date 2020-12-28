# frozen_string_literal: true

module Jak
  # Defines a set of custom Generators
  module Generators
    # Generates the Jak Configuration file
    class InitializerGenerator < Rails::Generators::Base
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

      desc <<~DESC
        Description:
            Copies Jaks initializer file to the `config/initializers` directory.
      DESC

      # Copy the configuration file to a sane place
      def copy_config_file
        template 'jak_initializer_config.rb', 'config/initializers/jak_initializer.rb'
      end
    end
  end
end
