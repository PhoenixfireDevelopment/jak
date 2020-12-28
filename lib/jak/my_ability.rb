# frozen_string_literal: true

# The Jak namespace
module Jak
  # The MyAbility Class which is the child of JakAbility
  class MyAbility < JakAbility
    def initialize(resource, &block)
      # Invoke Jak Ability methods
      super do
        instance_eval(&block) if block_given?
      end

      # Bail out early
      unless resource.present?
        puts 'Jak::MyAbility.initialize - Bail out No Resource Present!'
        return
      end

      # This is the dynamic permission functionality
      @yielded_namespaces.each do |namespace|
        next unless resource.respond_to?(:permissions, namespace)

        my_namespace = Jak.namespace_manager.find(namespace)

        # 360 no namespace
        raise NotImplementedError, "Namespace: '#{namespace}' was not found!" unless my_namespace

        if my_namespace.scoped_to_tenant?
          # Limited by Jak.tenant_id_column
          tenant_id_column = "#{Jak.tenant_id_column}_id"

          # Unrestricted Permissions: Not limited to the current_user per se.
          resource.permissions(namespace).select { |k| k.restricted == false }.each do |permission|
            # Check the resources permissions
            if permission.klass.constantize.column_names.include?(tenant_id_column)
              # Does this model have a tenant_id column in it...
              can permission.action.to_sym, permission.klass.constantize, tenant_id_column.to_sym => resource.send(tenant_id_column)
            else
              # Is it the tenant itself?
              can permission.action.to_sym, permission.klass.constantize, id: resource.send(tenant_id_column)
            end
          end

          # Restricted Permissions: Limit to not only the tenant (optionally), but to the column specified
          # For example:
          #   can :show, Lead, company_id: current_user.company_id, assignable_id: user.id
          # Is saying that they can show the leads for the company they're a part of and for leads assigned to this User.
          resource.permissions(namespace).select { |k| k.restricted == true }.each do |permission|
            # Check the resources permissions
            if permission.klass.constantize.column_names.include?(tenant_id_column)
              # puts "Doing that thing you want, for namespace: '#{namespace}', for klass: '#{permission.klass}', upon action of '#{permission.action}'"
              can permission.action.to_sym, permission.klass.constantize, tenant_id_column.to_sym => resource.send(tenant_id_column), permission.klass.constantize.send("my_#{namespace}_restrictions").to_sym => resource.id
            else
              # Is it the tenant itself?
              can permission.action.to_sym, permission.klass.constantize, id: resource.send(tenant_id_column)
            end
          end
        else
          # Absolute power! (Not restricted by Jak.tenant_id_column)
          resource.permissions(namespace).each do |permission|
            can permission.action.to_sym, permission.klass.constantize
          end
        end
      end # end @yielded_namespaces.each
    end # end initialize
  end
end
