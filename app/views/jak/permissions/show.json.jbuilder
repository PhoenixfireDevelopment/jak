# frozen_string_literal: true

json.partial! 'jak/permissions/permission', permission: @permission

# Roles
json.roles @permission.roles do |role|
  json.partial! 'roles/role', role: role
end

json.grants @permission.grants do |grant|
  json.extract! grant, :_id, :role_ids
end
