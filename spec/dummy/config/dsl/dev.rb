# frozen_string_literal: true

# config/dsl/dev.rb

puts 'DSL.RB HAS BEEN LOADED!'

# ===================================================================
# DSL : Setup permissions using our DSL
# ===================================================================
Jak.dsl do
  # Dummy Peon
  create_namespace('dummy') do
    scope_to_tenant true

    # NOTE: Don't preface the klass with '::', i.e. '::User' is wrong, while 'User' is correct
    create_constraint do
      klass 'User'
      i18n false
      actions %i[show]
      restrict :id
    end

    create_constraint do
      klass 'Lead'
      i18n false
      actions %i[manage]
      restrict :assignable_id
    end
  end

  ## Dummy Manager
  create_namespace('dummy_manager') do
    create_constraint do
      klass 'Company'
      i18n false
      actions %i[show update]
    end

    # Managers can see all users in the company
    create_constraint do
      klass 'User'
      i18n false
      actions %i[index]
      restrict :company_id
    end
  end

  # React JSON API
  create_namespace('react') do
    scope_to_tenant true

    # React API can manage all leads for the company
    create_constraint do
      klass 'Lead'
      i18n false
      actions %i[manage]
      restrict :company_id
    end

    # React API can index/show all roles for the company
    create_constraint do
      klass 'Role'
      i18n false
      actions %i[index show]
      restrict :company_id
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
    { klass: User, constraints: %i[show], only: true, restrict: true, namespace: 'dummy' },
    { klass: Lead, constraints: %i[manage], except: true, restrict: true, namespace: 'dummy' }
  ]
  default.create_roleset 'Sales Manager', [
    { klass: Company, constraints: %i[show update], only: true, restrict: false, namespace: 'dummy_manager' }
  ]
end
# ===================================================================
# End Rolesets
# ===================================================================
