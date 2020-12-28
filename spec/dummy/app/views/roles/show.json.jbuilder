# frozen_string_literal: true

json.partial! 'roles/role', role: @role

json.permissions @role.permissions do |permission|
  json.extract! permission, :action, :klass, :description, :namespace, :restricted
end
