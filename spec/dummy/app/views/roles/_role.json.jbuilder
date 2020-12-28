# frozen_string_literal: true

json.extract! role, :id, :name, :key, :created_at, :updated_at
json.url main_app.company_role_url(role.company, role, format: :json)
