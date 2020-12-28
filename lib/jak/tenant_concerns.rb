# frozen_string_literal: true

# The Jak module.
module Jak
  # Concerns for patching into the tenant.
  module TenantConcerns
    extend ActiveSupport::Concern

    included do
      has_many :roles, dependent: :destroy, class_name: Jak.role_klass.to_s, foreign_key: Jak.roles_foreign_key.to_s if Jak.roles_foreign_key.present?

      # Monkey patch this on to create the Rolesets from the Initializer config
      def create_default_roles
        # Create the default Rolesets
        Jak.rolesets.each do |role_set|
          my_role                = roles.find_or_create_by(name: role_set.role_name, key: role_set.role_name.parameterize, company: self)
          my_role.permission_ids = role_set.permission_ids
          my_role.save!
        end
      end
    end

    # Adds an association for the tenant to have many roles
    module ClassMethods
    end
  end
end
