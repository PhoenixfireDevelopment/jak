# frozen_string_literal: true

# The Jak module.
module Jak
  # The Core module.
  module Core
    # Represents a Namespace of Permissions and Constraints from the DSL.
    # @!attribute name
    #   The name of the Jak Namespace.
    # @!attribute scoped_to_tenant_id
    #   Is this Namespace also restricted to `Jak.tenant_id_column` ?
    # @!attribute namespace_constraints
    #   A set of the constraints which match this Namespace.
    class Namespace
      attr_accessor :name
      attr_reader :scoped_to_tenant_id

      # Create a new instance of a Namespace
      # @param namespace_name [Symbol] The name of the Jak Namespace.
      # @note Accepts a block.
      def initialize(namespace_name = nil, &block)
        if block_given?
          instance_eval(&block)
        else
          raise ArgumentError if namespace_name.nil?

          self.name = namespace_name
        end
      end

      # DSL
      def scope_to_tenant(boolean)
        raise ArgumentError, 'Invalid value for: `scope_to_tenant`!' unless [true, false].include?(boolean)

        @scoped_to_tenant_id = boolean
      end

      # Is this scope restricted to the `Jak.tenant_id_column`?
      def scoped_to_tenant?
        !!scoped_to_tenant_id
      end

      # This is being called from Jak::Core::DSLProxy.create_namespace under `instance_eval`
      def create_constraint(&block)
        raise ArgumentError, '`create_constraint` requires a block argument!' unless block_given?

        # TODO: you have to add this constraint to the constraint manager (isn't this just DSL.registry?)
        constraint = Jak::Core::Constraint.new(name)
        constraint.instance_eval(&block)

        # Register the constraint with the Constraint Manager
        ::Jak.constraint_manager.register(constraint)
      end

      # The constraints for this namespace (if any)
      def namespace_constraints
        @namespace_constraints ||= Jak::Core::DSL.registry.fetch(name.to_s, {})
      end

      # Find the constraints for this namespace for a given klass
      def namespace_constraints_for_klass(klass = nil)
        return [] if klass.nil?

        namespace_constraints.filter { |constraint| constraint.my_klass == klass.to_s }
      end

      # What classes have an invocation for this namespace?
      def namespace_invokers
        namespace_constraints.map(&:my_klass)
      end
    end
  end
end
