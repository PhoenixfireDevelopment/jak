# frozen_string_literal: true

# The Jak module.
module Jak
  # The Core Namespace
  module Core
    # Represents a set of constraints for a Permission definition.
    # @!attribute my_klass
    #   The model name of the class for this Permission definition.
    # @!attribute my_actions
    #   The array of actions for this Permission definition.
    # @!attribute my_namespace
    #   What Namespace this Permission definition is included in.
    # @!attribute my_i18n
    #   Should this constraint to an i18n lookup from the locale file?
    # @!attribute my_restrictions
    #   Determines if this Permission definition will be scoped to a specific resource ID.
    # @!attribute my_mongo_permission_ids
    #   The database ID's of the mongo DB permissions representing this constraint
    class Constraint
      attr_accessor :my_klass, :my_actions, :my_namespace, :my_i18n, :my_restrictions, :my_mongo_permission_ids

      # Create a new instance of a Constraint. It defaults `my_actions` to whatever the initializer specifies as the default_actions, or whatever Jak.default_actions is set to.
      # @param namespace [String] The Jak Namespace this constraint is scoped to
      def initialize(namespace = nil)
        raise ArgumentError, '`namespace` is required!' if namespace.nil?

        # Set the namespace
        self.my_namespace = namespace

        # TODO: maybe add an optional `uuid` attribute so I can do `Jak.constraint_manager.find_by_uuid('some_uuid')` ??

        # Set the default actions
        self.my_actions ||= Jak.default_actions
      end

      # @param my_klass [String] The name of the ruby class this constraint will be for.
      def klass(my_klass = nil)
        # Can't be nil
        raise ArgumentError, '`klass` cannot be nil!' if my_klass.nil?

        # Has to be a String type
        raise ArgumentError, '`klass` must be a String!' unless my_klass.is_a?(String)

        self.my_klass = my_klass
      end

      # @param my_namespace [String] The name of the Jak Namespace this constraint will live inside.
      def namespace(my_namespace = nil)
        # Can't be nil
        raise ArgumentError, '`namespace` cannot be nil!' if my_namespace.nil?

        # Has to be a String type
        raise ArgumentError, '`namespace` must be a String!' unless my_namespace.is_a?(String)

        self.my_namespace = my_namespace
      end

      # @param my_i18n [Boolean] Does this Constraint use custom i18n translations?
      def i18n(my_i18n = nil)
        raise ArgumentError, '`i18n` must be a Boolean!' unless [true, false].include?(my_i18n)

        self.my_i18n = my_i18n
      end

      # @param my_mongo_permission_ids [Array] An Array that contains the list of the Mongo Permission id's from the mongo database.
      def mongo_permission_ids(my_mongo_permission_ids = [])
        raise ArgumentError, '`mongo_permission_ids` must be an Array!' unless my_mongo_permission_ids.is_a?(Array)

        self.my_mongo_permission_ids = my_mongo_permission_ids
      end

      # @param my_actions [Array] The actions this Constraint will check against.
      def actions(my_actions = [])
        raise ArgumentError, '`actions` must be an Array!' unless my_actions.is_a?(Array)

        self.my_actions = my_actions
      end

      # @param my_restrictions [Symbol] If this constraint should limit the permissions to a specific database column. I.E. Leads would restrict `show` to say that `User.id` must equal `Lead.assignable_id`.
      def restrict(my_restrictions = nil)
        raise ArgumentError, '`restrict` cannot be nil!' if my_restrictions.nil?

        # Requires a Symbol
        raise ArgumentError, '`restrict` must be a Symbol!' unless my_restrictions.is_a?(Symbol)

        self.my_restrictions = my_restrictions
      end
    end
  end
end
