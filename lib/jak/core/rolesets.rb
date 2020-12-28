# frozen_string_literal: true

require 'singleton'

# The Jak module.
module Jak
  # The Core module.
  module Core
    # A Singleton instance which manages the DSL for defining "Rolesets"
    # These are predefined Roles coupled with their default permissions.
    class Rolesets
      include Singleton
      include Enumerable

      # Default it to an empty Set
      def initialize
        @my_rolesets = Set.new
      end

      # Let us configure the default rolesets via a block
      def defaults
        yield self
      end

      # Define a new Roleset enttry
      # param role_name [String] The name of the Jak Permission Set to create.
      # @param [Hash] options Various options to pass into the Jak Roleset.
      # @option options [String] :role_name The name of the Role.
      # @option options [Array<Hash>] :spine An array of Hash items for each permission set being granted to the Jak Roleset.
      def create_roleset(role_name, options = {}, &block)
        # Don't add existing Default Permission Sets
        new_roleset = Jak::Core::RoleSet.new(role_name, options, &block)
        Jak.rolesets.add(new_roleset)
      end

      # For including Enumerable
      def each
        @my_rolesets.each do |roleset|
          yield(roleset)
        end
      end

      # Return an array of the Rolesets
      def to_a
        @my_rolesets.to_a
      end

      # Return the count of how many Rolesets we have
      def count
        @my_rolesets.size
      end

      # Let us search through the Rolesets for a specific Roleset
      # @param thing [String] The name of the Jak Roleset to test for inclusion
      def include?(thing)
        @my_rolesets.map(&:role_name).include?(thing)
      end

      # TODO: Cache me
      # Let us find a specific Roleset
      # @param roleset_name [String] The name of the Jak Roleset to find.
      def find(roleset_name)
        @my_rolesets.detect { |k| (k.role_name == roleset_name) }
      end

      # Let me add a Roleset
      # @param roleset [String] The name of the Jak Roleset to add.
      def add(roleset)
        @my_rolesets.add(roleset) unless @my_rolesets.include?(roleset)
      end

      # Let me remove a Roleset
      # @param roleset [String] The name of the Jak Roleset to remove.
      def remove(roleset)
        @my_rolesets.delete(roleset) if @my_rolesets.include?(roleset)
      end

      private

      def clear!
        @my_rolesets.clear
      end
    end
  end
end
