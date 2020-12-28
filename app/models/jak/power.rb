# frozen_string_literal: true

# The Jak module
module Jak
  # Defines the union between a User and a Role
  class Power < ApplicationRecord
    belongs_to :user, class_name: Jak.user_klass.to_s, foreign_key: 'user_id'
    belongs_to :role, class_name: Jak.role_klass.to_s

    # Note: We don't allow the user to be assigned the same power twice (it wouldn't make sense!)
    # Note: We don't require the explicit **presence** of `user_id` because if we did, then we can't do `build` properly
    validates :user_id,
              uniqueness: { scope: [:role_id] }

    # We DO require a user and a role though!
    validates :user, presence: true
    validates :role_id, presence: true

    # Roles and Users should be in the same Tenant (Company)
    validate :no_cross_contamination, if: proc { |k| Jak.tenant_id_column.present? && k.user_id.present? && k.role_id.present? }

    private

    def no_cross_contamination
      tenant_id_column = "#{Jak.tenant_id_column}_id".to_sym
      if user.send(tenant_id_column) != role.send(tenant_id_column)
        # user.company_id and role.company_id are not the same values
        errors.add(:base, 'Role and User must be in the same Tenant!') && (return false)
      end
      true # They're the same
    end
  end
end
