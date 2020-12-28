# frozen_string_literal: true

# support/dsl/test1.rb

# ===================================================================
# DSL : Setup permissions using our DSL
# ===================================================================
Jak.dsl do
  create_namespace('rspec') do
    scope_to_tenant true

    create_constraint do
      klass 'User'
      i18n false
      actions %i[show]
      restrict :id
    end

    create_constraint do
      klass 'Lead'
      i18n false
      actions %i[index show]
      restrict :assignable_id
    end
  end
end
# ===================================================================
# End DSL
# ===================================================================

# ===================================================================
# Rolesets : Setup the default Role Sets (Roles with default permissions)
# ===================================================================
Jak.rolesets.defaults do |default|
  default.create_roleset 'Sales Representative', [
    { klass: User, constraints: %i[show], only: true, restrict: true, namespace: 'rspec' },
    { klass: Lead, constraints: %i[index show], only: true, restrict: true, namespace: 'rspec' }
  ]
end
# ===================================================================
# End Rolesets
# ===================================================================
