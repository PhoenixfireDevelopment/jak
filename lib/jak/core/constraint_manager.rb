# frozen_string_literal: true

require 'singleton'

# The Jak module.
module Jak
  # The Core module.
  module Core
    # Manages all the Constraints which are parsed from the DSL.
    # @!attribute constraints
    #   The Set of Constraints.
    class ConstraintManager
      include Singleton
      include Enumerable

      attr_reader :constraints

      # It's a nested hash of keys where the outer keys are the class names, and the inner keys are the names
      # of the namespace and it points to a constraint PORO object which was parsed from the DSL
      def initialize
        @constraints = {}
      end

      # For including Enumerable
      def each(&block)
        @constraints.each do |constraint|
          block.call(constraint)
        end
      end

      # Register a new constraint
      def register(my_constraint = nil)
        return nil if my_constraint.nil?

        # TODO: rescue?
        klass = my_constraint.my_klass.constantize

        # Bail out early. NOTE: I think this prevents you from saying like:
        # * I can see my own user account
        # * I can see users who are on my team
        # As separate constraints inside the same namespace
        if @constraints[klass].try(:[], my_constraint.my_namespace)
          puts "Jak::Core::ConstraintManager.register - WARN: Rejecting duplicate klass: '#{my_constraint.my_klass}' constraints for the same namespace: '#{my_constraint.my_namespace}'!"
          return true
        end

        @constraints[klass] ||= {}
        @constraints[klass][my_constraint.my_namespace.to_s] = my_constraint

        # Only add valid things to the registry
        ::Jak::Core::DSL.registry[my_constraint.my_namespace.to_s].add(my_constraint)

        # TODO: what if my_actions is `:manage` ? Shouldn't it create permissions for everything?

        # Create the permission here
        my_constraint_permission_ids = my_constraint.my_actions.flat_map do |my_action|
          perm = Jak::Permission.find_or_create_by(action: my_action,
                                                   klass: my_constraint.my_klass,
                                                   namespace: my_constraint.my_namespace,
                                                   restricted: my_constraint.my_restrictions.present?,
                                                   description: my_constraint.my_restrictions.present? ? "#{my_constraint.my_namespace}.#{my_constraint.my_klass}.#{my_action}[:#{my_constraint.my_restrictions}]" : "#{my_constraint.my_namespace}.#{my_constraint.my_klass}.#{my_action}")
          perm.id.to_s
        end
        # Set them all at once for this constraint
        my_constraint.my_mongo_permission_ids = my_constraint_permission_ids

        # Add this constraint Klass to the invokers definition
        begin
          Jak.invokers.add(klass)
        rescue StandardError => e
          # Log an error!
          puts "Jak::Core::ConstraintManager.add_constraint - Exception Caught! #{e.message}"
        end
      end

      # Find a constraint from the Constraint Manager
      # @param [String] my_namespace The namespace to search under
      # @param [String] my_klass The class to search under
      def find(my_namespace = nil, my_klass = nil)
        return nil if my_namespace.nil?
        return nil if my_klass.nil?

        begin
          klass = my_klass&.constantize

          # Make sure the class is in the hash
          return nil unless constraints.keys.include?(klass)

          constraints[klass].fetch(my_namespace, nil) if klass
        rescue StandardError => e
          puts "Jak::Core::ConstraintManager.find - Exception Caught! #{e.message}"
          nil
        end
      end

      # Remove a constraint, if it exists.
      def remove(my_namespace = nil, my_klass = nil)
        return nil if my_namespace.nil?
        return nil if my_klass.nil?

        klass = my_klass.constantize

        return nil unless constraints.fetch(klass, nil).present?

        # Delete the constraint from that namespace
        constraints[klass].delete(my_namespace)
      end

      # Count how many constraints we have across the board or for a given klass
      def count(my_klass = nil)
        # Across the board
        return constraints.values.sum { |k| k.values.size } if my_klass.nil?

        klass = my_klass.constantize
        if constraints.fetch(klass, {}).present?
          # Looking at a class
          constraints.fetch(klass).values.size
        else
          # Don't exist
          return nil
        end
      end

      private

      # Clear the constraints hash
      def clear!
        @constraints.clear
      end
    end
  end
end
