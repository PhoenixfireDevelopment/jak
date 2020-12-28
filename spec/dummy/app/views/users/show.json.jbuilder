# frozen_string_literal: true

json.partial! 'users/user', user: @user

json.dummy_permissions @user.permissions('dummy') do |permission|
  json.extract! permission, :action, :klass, :description, :namespace, :restricted
end
