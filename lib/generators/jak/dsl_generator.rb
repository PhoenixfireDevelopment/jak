# frozen_string_literal: true

module Jak
  # Defines a set of custom Generators
  module Generators
    # Generates a Jak DSL file
    class DslGenerator < Rails::Generators::Base
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

      desc <<~DESC
        Description:
            Generates a default DSL profile under `config/dsl/dev.rb`.
      DESC

      # Copy the template file to some sane place
      def copy_config_file
        template 'dsl_development.rb', 'config/dsl/dev.rb'
      end
    end
  end
end
