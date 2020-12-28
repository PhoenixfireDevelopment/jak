# frozen_string_literal: true

json.extract! user, :id, :name, :company_id, :created_at, :updated_at

json.url main_app.company_user_url(user.company, user, format: :json)

# Roles
json.roles user.roles do |role|
  json.partial! 'roles/role', role: role
end
