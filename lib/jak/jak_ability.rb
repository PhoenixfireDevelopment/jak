# frozen_string_literal: true

# The Jak namespace
module Jak
  # The parent Ability class, used to configure what namespaces to yield to
  class JakAbility
    cattr_accessor :yielded_namespaces
    def initialize(_resource, &block)
      @yielded_namespaces = Set.new

      # Indicate what namespaces we want included
      instance_eval(&block) if block_given?
    end

    # Add a namespace to the list of yielded namespaces
    def yield_namespace(namespace_name)
      raise NotImplementedError, "Namespace: '#{namespace_name}' is not defined!" unless Jak.namespace_manager.include?(namespace_name)

      @yielded_namespaces.add(namespace_name)
    end
  end
end
