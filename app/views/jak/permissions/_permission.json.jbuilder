# frozen_string_literal: true

json.extract! permission, :_id, :action, :klass, :description, :namespace, :restricted
json.url jak.permission_url(permission, format: :json)
