# frozen_string_literal: true

# The Jak module.
module Jak
  # Encapsulates configuration directives for the Jak engine.
  # @!attribute default_actions
  #   The default set of permissions in the entire system.
  # @!attribute roles_foreign_key
  #   The id column for the Role foreign relation
  # @!attribute tenant_id_column
  #   The name of the column which will be present on Tenant models. i.e "company_id" would specify 'company'
  module Configuration
    extend ActiveSupport::Concern

    # The string representation of the classes we define or integrate with.
    # @return [Array]
    #   * :power_class [String] The name of the class that links Roles and Users.
    #   * :role_class [String] The name of the class that will implement the Role functionality.
    #   * :user_class [String] The name of the class that will implement the User functionality.
    #   * :tenant_class [String] The name of the class that will implement the Tenant functionality.
    #   * :user_ability_class [String] The name of the class that will implement the CanCanCan User Ability functionality.
    KLASS_CONSTANTS = %i[
      power_class
      role_class
      user_class
      tenant_class
      user_ability_class
    ].freeze

    # When this module is extended, set all configuration options to their default values.
    # @param [Hash] base the options to create a message with.
    # @option base [Array] :default_actions The default set of permissions in the entire system.
    # @option base [String] :roles_foreign_key What key is used to link up Roles and Tenant
    def self.extended(base)
      # Get our constants setup
      KLASS_CONSTANTS.each { |k| base.send(:mattr_accessor, k.to_sym) }

      # TODO: tenant_id_column shouldn't be 'company' it should be 'company_id'?
      base.send(:mattr_accessor, :default_actions)
      base.send(:mattr_accessor, :roles_foreign_key)
      base.send(:mattr_accessor, :tenant_id_column)
      base.send(:mattr_accessor, :invokers)
      base.send(:mattr_accessor, :constraint_manager)
      base.send(:mattr_accessor, :namespace_manager)
      base.send(:mattr_accessor, :rolesets)
      base.send(:mattr_accessor, :dsl_profile_path)

      # Reset the values
      base.reset

      # Setup our Klass Constants
      base.setup_klass_constants
    end

    # Resets all the values to their defaults.
    def reset
      # Power (Don't Override)
      self.power_class = 'Jak::Power'

      # What model to use for the Ability file
      self.user_ability_class = nil

      # Role (Override)
      self.role_class = nil

      # User (Override)
      self.user_class = nil

      # Default Jaks actions
      self.default_actions ||= %i[manage index show new create edit update destroy].freeze

      # Let them specify the exact column
      self.tenant_id_column = nil

      # Set the default invokers to an empty set
      self.invokers = Set.new

      # profiles
      # self.profiles = {test1: 'spec/support/dsl/test1', dev: 'spec/dummy/config/dsl/dev' }
    end

    # Allows setting all configuration options in a block.
    def configure
      yield self
    end

    # Change *_class into *_klass so we have the actual constant.
    def setup_klass_constants
      Jak::Configuration::KLASS_CONSTANTS.each do |klass|
        send(:define_singleton_method, klass.to_s.gsub(/(_class)$/, '_klass').to_s.to_sym) do
          # TODO: rescue block
          send(klass).try(:constantize)
        end
      end
    end
  end
end
