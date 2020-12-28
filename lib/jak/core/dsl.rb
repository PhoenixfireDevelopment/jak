# frozen_string_literal: true

module Jak
  # The Core Namespace
  module Core
    # Domain Specific Language
    module DSL
      # This is a hash where the key is the namespace name, and the value is a Set of all the Constraints defined from the initializer file for that Namespace.
      @@registry = {}

      # DSL nesting tracking
      @@lexical = []

      # This could actually hold namespaces and/or constraints as a hash

      # For DSL-syntax nesting requirements
      def self.lexical
        @@lexical
      end

      # The registry is used to
      # Used later on
      def self.registry
        @@registry
      end

      # Lookup the symbol we want
      def self.lexical?(symbol = nil)
        raise ArgumentError, 'Symbol is required!' if symbol.nil?

        defined?(::Jak::Core::DSL.lexical) && ::Jak::Core::DSL.lexical.last == symbol.to_sym
      end

      # Start off the DSL. Requires a block argument
      def self.define(&block)
        raise ArgumentError, '`define` requires a block argument!' unless block_given?

        @@lexical.push(:define)
        dsl_proxy = ::Jak::Core::DSLProxy.new
        dsl_proxy.instance_eval(&block)

        # Return the current value of @@lexical, and the value we just popped off
        [@@lexical, @@lexical.pop]
      end
    end # End DSL module

    # The actual instance method stuff
    class DSLProxy
      # Add a new namespace to our Namespace Manager
      # @param name [String] The name of the namespace
      # @note Accepts a block.
      # This can only be called from within the `define` block
      def create_namespace(name = nil, &block)
        # Requires a block
        raise ArgumentError, '`create_namespace` requires a block argument!' unless block_given?

        # Require a name
        raise ArgumentError, '`create_namespace` requires a name!' if name.nil?

        # requires the proper nesting in the DSL
        raise ArgumentError, '`create_namespace` must be called from `define`!' unless ::Jak::Core::DSL.lexical?(:define)

        ::Jak::Core::DSL.lexical.push(:create_namespace)

        # Create a new Namespace PORO
        namespace = Jak::Core::Namespace.new(name.to_s)

        # Add it to our registry. This doesn't mean it will go into the Constraint Manager, it only means the DSL has parsed it.
        ::Jak::Core::DSL.registry[name] ||= Set.new

        # Add this to the namespace manager
        Jak.namespace_manager.add(namespace)

        # Delegate off the DSL calls to namespace
        namespace.instance_eval(&block)

        # Return the current value of @@lexical, and the value we just popped off
        [::Jak::Core::DSL.lexical, ::Jak::Core::DSL.lexical.pop]
      end
    end
  end
end
