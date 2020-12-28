# frozen_string_literal: true

require 'singleton'

# TODO: it would be nice if the end-programmer could tie into the lifecycle of the initializer hooks.

# The Jak module.
module Jak
  # The Middleware module.
  module Middleware
    # A proxy for Proc's
    # NOTE: all callback methods must return a Proc!
    class Proxy
      # First Callback
      def self.before_configuration
        proc { puts 'jak.config.before_configuration' }
      end

      # Second callback
      def self.before_initialize
        proc { puts 'jak.config.before_initialize' }
      end

      # Third callback
      def self.before_eager_load
        proc { puts 'jak.config.before_eager_load' }
      end

      # TODO: specs that assert that it loads the dsl_profile_path and calls require
      # Pre-fourthish hook which let's app's tie into our engine before actual `to_prepare` runs
      def self.jak_engine_to_prepare
        proc { puts 'jak.initializer.to_prepare' }
      end

      # Fourth Callback
      def self.to_prepare
        proc do
          puts 'jak.config.to_prepare'

          # Load our profiles here
          if Jak.dsl_profile_path.present?
            puts 'Loading DSL Profile....'
            require Jak.dsl_profile_path.to_s
            puts 'Done loading DSL Profile!'
          end

          ### Invokers
          # Monkey patch Jak methods into the invokers
          Jak.invokers.each do |invoker|
            # Monkey Patch
            invoker.class_eval <<-RUBY
              cattr_accessor :my_constraint_keys

              # TODO: I could just store a PORO on the class itself!
              # TODO: WHY DO I CARE???
              # Returns nil if no namespace exists. False if there are no permissions for it.
              # Returns true if there are permissions for the specified namespace.
              def self.constraints_for_namespace?(namespace_name)
                my_namespace = Jak.namespace_manager.find(namespace_name)
                if my_namespace
                  my_namespace.namespace_invokers.include?(self.to_s)
                else
                  # Didn't find a namespace
                  nil
                end
              end

              # TODO: WHY DO I CARE???
              # TODO: Cache Me
              # Returns the namespace_constraints for the namespace, if it exists
              def self.constraints_for_namespace(namespace_name)
                return nil unless constraints_for_namespace?(namespace_name)
                my_namespace = Jak.namespace_manager.find(namespace_name)
                if my_namespace
                  my_namespace.namespace_constraints
                else
                  nil
                end
              end
            RUBY

            # TODO: WHY DO I CARE???
            # Set the class variables
            my_constraint      = Jak.constraint_manager.constraints.try(:[], invoker)
            my_constraint_keys = my_constraint.try(:keys).present? ? my_constraint.keys : nil
            invoker.send(:my_constraint_keys=, my_constraint_keys)

            # Patch on the dynamic permissions
            invoker.my_constraint_keys.each do |constraint_key|
              invoker.class_eval <<-RUBY
                self.send(:define_singleton_method, "#{constraint_key}_permissions".to_sym) do
                  Jak.namespace_manager.dynamic_permissions(self, "#{constraint_key}")
                end

                self.send(:define_singleton_method, "my_#{constraint_key}_restrictions".to_sym) do
                  Jak.namespace_manager.dynamic_constraint_restriction_keys(self, "#{constraint_key}")
                end
              RUBY
            end
          end
          # End Invokers
          ### End Invokers

          ### Roles
          # Role
          if defined?(Jak.role_klass) && Jak.role_klass.present?
            Jak.role_klass.class_eval do
              include Jak::RoleConcerns
            end
          end
          ### End Roles

          ### Tenant
          if defined?(Jak.tenant_klass) && Jak.tenant_klass.present? && !Jak.roles_foreign_key.nil?
            Jak.tenant_klass.class_eval do
              include Jak::TenantConcerns
            end
          end
          ### End Tenant

          ### User
          if defined?(Jak.user_klass) && Jak.user_klass.present?
            Jak.user_klass.class_eval do
              has_many :powers, dependent: :destroy, class_name: Jak.power_klass.to_s, foreign_key: 'user_id'
              has_many :roles, through: :powers, class_name: Jak.role_klass.to_s, source: :role

              # This allows us to check abilities on users who are not the current one
              delegate :can?, :cannot?, to: :ability

              def ability
                @ability ||= ::Ability.new(self)
              end

              # Permissions for this user and the specificed namespace
              def permissions(my_namespace = nil)
                raise ArgumentError 'Namespace is required!' if my_namespace.nil?
                raise NotImplementedError, "Namespace: '#{my_namespace}' was not defined!" unless Jak.namespace_manager.namespace_names.include?(my_namespace)

                roles.flat_map do |role|
                  role.permissions(false).with_namespace(my_namespace)
                end.compact
              end
            end
          end
          ### End User

          # Rolesets
          # Populate the Rolesets with pre-defined roles
          Jak.rolesets.each(&:prepare)
          ### End Rolesets
        end
        # End of Proc
      end

      # Fifth Callback
      def self.after_initialize
        proc { puts 'jak.config.after_initialize' }
      end
    end
  end
end
