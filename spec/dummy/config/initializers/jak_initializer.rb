# frozen_string_literal: true

# config/initializers/jak_initializer.rb

Jak.configure do |config|
  # Set this to specify your own implementation of Role
  config.role_class = 'Role'

  # Set this to specify your own implementation of User
  config.user_class = 'User'

  # What key is used to link up Roles and Tenant (Set to nil if you use Rolify!)
  config.roles_foreign_key = 'company_id'

  # Set this to specify what Jak should limit the permissions to (i.e. Company, School)
  config.tenant_class = 'Company'

  # Set this to specify the default actions which Jak should generate for a model
  config.default_actions = %i[manage index show create update destroy]

  # Set the default limiting column (Set me)!
  config.tenant_id_column = 'company'

  # Set this to specify the User Ability class
  config.user_ability_class = 'Ability'
end
