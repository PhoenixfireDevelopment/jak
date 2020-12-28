# frozen_string_literal: true

module Jak
  # Defines a set of custom Generators
  module Generators
    # Generates an Ability file for Jak
    class AbilityGenerator < Rails::Generators::Base
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

      desc <<~DESC
        Description:
            Copies Jaks ability file to the `app/models/jak_ability.rb` directory.
      DESC

      # Copy the template file to some sane place
      def copy_config_file
        template 'ability_config.rb', 'app/models/jak_ability.rb'
      end
    end
  end
end
