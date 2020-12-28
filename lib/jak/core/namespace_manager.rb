# frozen_string_literal: true

require 'singleton'

# The Jak module.
module Jak
  # The Core module.
  module Core
    # Contains a lookup table of all the Permission Namespaces.
    # @!attribute namespaces
    #   The Set of Namespaces for Permission scoping.
    class NamespaceManager
      include Singleton
      include Enumerable

      # Initializes a new NamespaceManager. This is a Singleton
      def initialize
        @namespaces = Set.new
      end

      # For including Enumerable
      def each(&block)
        @namespaces.each do |namespace|
          block.call(namespace)
        end
      end

      # Find a Namespace from the Namespace Manager
      # @param namespace_name [String] The name of the Jak Namespace to search for.
      def find(namespace_name = nil)
        return nil if namespace_name.nil?

        @namespaces.find { |k| k.name == namespace_name.to_s }
      end

      # Let us search through the Namespace Manager for a specific Namespace
      # @param my_namespace [String] The name of the Jak Namespace to test for inclusion
      def include?(my_namespace)
        namespace_names.include?(my_namespace)
      end

      # Add a Namespace to the set
      def add(my_namespace = nil)
        return nil if my_namespace.nil?

        @namespaces.add(my_namespace)
      end

      # The names of all the Namespaces
      def namespace_names
        @namespaces.map(&:name)
      end

      # Return just the list of constraints for this Namespace
      def dynamic_constraints(klass, namespace_name)
        namespace = find(namespace_name) # see if this namespace exists
        namespace&.namespace_constraints_for_klass(klass)
      end

      # Determines what constraint restrictions are for a klass in a given namespace
      def dynamic_constraint_restriction_keys(klass, namespace_name)
        konstraints = dynamic_constraints(klass, namespace_name)
        case konstraints.class.to_s
        when 'Array'
          raise NotImplementedError, 'Jak::Core::NamespaceManager.dynamic_constraint_restriction_keys Receive an array with multiple items in it!' if konstraints.length != 1

          konstraints.first.my_restrictions
        when 'Jak::Core::Constraint'
          raise NotImplementedError, 'Jak::Core::NamespaceManager.dynamic_constraint_restriction_keys Receive an unknown object!' unless konstraints.is_a?(Jak::Core::Constraint)

          konstraints.my_restrictions
        end
      end

      # Build the actual permissions from the constraints
      def dynamic_permissions(klass, namespace_name)
        klass       = klass.constantize if klass.is_a?(String)
        konstraints = dynamic_constraints(klass, namespace_name)
        result      = {}

        # Bail out early
        return result unless konstraints

        # Build the actual constraints
        konstraints.each do |konstraint|
          konstraint.my_actions.each do |this_konstraint|
            result[this_konstraint] = {
              action: this_konstraint.to_s,
              klass: konstraint.my_klass,
              description: constraint_description(klass, konstraint, this_konstraint),
              namespace: konstraint.my_namespace,
              restricted: konstraint.my_restrictions.present?,
              restrict_by: konstraint.my_restrictions
            }
          end
        end
        result
      end

      # Try to generate or lookup a name for this Permission
      def constraint_description(klass, my_constraint, constraint_action)
        if my_constraint.my_i18n
          I18n.t(".activerecord.attributes.#{klass.name.to_s.constantize.model_name.singular}.jak.#{constraint_action}", default: I18n.t(".jak.constraints.#{constraint_action}"))
        else
          tenant_name = 'Application'
          case constraint_action.to_sym
          when :add
            "Permits adding and creating new #{klass.model_name.human.pluralize.downcase}."
          when :read
            "Permits viewing all #{klass.model_name.human.pluralize.downcase} and any specific #{klass.model_name.human.downcase}."
          when :modify
            "Permits editing and updating an existing #{klass.model_name.human.downcase}."
          when :remove
            "Permits removing an existing #{klass.model_name.human.downcase}."
          when :manage
            "Grants all power to create, read, update, and remove #{klass.model_name.human.pluralize.downcase} for the #{tenant_name}."
          when :index
            "Permits viewing the index of all #{klass.model_name.human.pluralize.downcase} for the #{tenant_name}."
          when :show
            "Permits viewing a specific #{klass.model_name.human.downcase} for the #{tenant_name}."
          when :new
            "Permits viewing the new #{klass.model_name.human.downcase} button and page for the #{tenant_name}."
          when :create
            "Permits creating a new #{klass.model_name.human.downcase} for the #{tenant_name}."
          when :edit
            "Permits viewing the edit #{klass.model_name.human.downcase} button and page for the #{tenant_name}."
          when :update
            "Permits updating an existing #{klass.model_name.human.downcase} for the #{tenant_name}."
          when :destroy
            "Permits removing an existing #{klass.model_name.human.downcase} from the #{tenant_name}."
          else
            I18n.t(".activerecord.attributes.#{klass.model_name.singular}.jak.#{constraint_action}", default: I18n.t(".#{constraint_action}"))
          end
        end
      end

      private

      def clear!
        @namespaces.clear
      end
    end
  end
end
