# frozen_string_literal: true

# TODO: rename spine to payload

# The Jak module.
module Jak
  # The Core Namespace
  module Core
    # Defines a permission set for a pre-defined Role.
    # @!attribute role_name
    #   The name of the Role to be granted this Permission Set.
    # @!attribute spine
    #   An array of hash items that define the Permissions in this set.
    # @!attribute permission_ids
    #   An array of Jak::Permission ID's for fast lookup
    class RoleSet
      attr_accessor :role_name, :spine, :permission_ids

      # Mandatory values which must be passed as hash keys when defining options
      MANDATORY_KEYS = %i[klass namespace constraints].freeze

      # Setup the data for this new RoleSet
      # param my_role_name [String] The name of the Jak Permission Set to create.
      # @param my_spine [Array<Hash>] An array of Hash items for each permission set being granted to the Jak RoleSet.
      def initialize(my_role_name, my_spine = [])
        raise ArgumentError, 'Role Name is required!' if my_role_name.blank?

        validate_spine!(my_spine)

        self.role_name = my_role_name
        self.spine     = my_spine
      end

      # Prepare everything by parsing the appropriate data. This is called with the Jak Engine invokes the '.to_prepare' initializer.
      def prepare
        return false if spine.empty?

        # Spine is:
        # [
        #   {klass: Lead, constraints: [:manage], except: true, restrict: true, namespace: :frontend},
        #   {klass: Company, constraints: [:show, :edit, :update], only: true, restrict: false, namespace: :frontend}
        # ]

        # Start with an empty set of Jak::Permission IDS
        my_permission_ids = Set.new

        # Go through the entire defined payload, plucking out keys
        spine.each do |c|
          klass = c.fetch(:klass, nil)
          constraints = c.fetch(:constraints, nil)
          except      = c.fetch(:except, nil)
          only        = c.fetch(:only, nil)
          restrict    = c.fetch(:restrict, nil)
          namespace   = c.fetch(:namespace, nil)

          # Find out what actions they want
          begin
            my_constraint = Jak.constraint_manager.constraints.dig(klass, namespace.to_s)

            # Check for Options
            if except.present?
              desired_actions = Jak.default_actions - my_constraint.my_actions
            elsif only.present?
              # constraints are the actions that come in from the roleset directive
              # my_constraint.my_actions is set through the DSL inside create_constraint -> actions
              desired_actions = my_constraint.my_actions.select { |k| constraints.include?(k) }
            end

            permissions = Jak::Permission.with_namespace(namespace).with_klass(klass)

            # Manage, vs. exclusion.
            if constraints.include?(:manage)
              permissions = permissions.with_actions(['manage'])
            else
              # When a constraint is created with only `:manage` it doesn't create permissions for all
              # the other default actions, it only creates one Permission with action of `:manage`. So,
              # we don't want to try to limit things here.
              permissions = permissions.with_actions(desired_actions) if desired_actions
            end

            permissions = permissions.restricted if restrict

            # This is a Set, so you have to use `.add` method not shovel operator
            my_permission_ids.add(permissions.to_a.pluck(:id).flat_map(&:to_s).reject(&:nil?).flatten)
          rescue StandardError => e
            "::Jak::Core::RoleSet.prepare: Failed to prepare RoleSet, message: #{e.message}"
          end
        end

        # TODO: Cache Me
        # Return that list of permission_ids
        self.permission_ids = my_permission_ids.flat_map { |k| k }
      end

      # Returns the set of Mongo Permissions associated with this RoleSet
      def my_mongo_permissions
        Jak::Permission.where(:id.in => permission_ids).to_a unless permission_ids.blank?
      end

      private

      # Raise an error if required keys are missing
      def validate_spine!(my_spine = [])
        raise ArgumentError, 'Spine is required!' if my_spine.empty?

        raise ArgumentError, 'Invalid RoleSet Payload!' if my_spine.any? do |entry|
          ::Jak::Core::RoleSet::MANDATORY_KEYS.any? { |required_key| !entry.keys.include?(required_key) }
        end
      end
    end
  end
end
