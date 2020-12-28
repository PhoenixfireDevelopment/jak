# frozen_string_literal: true

json.extract! company, :id, :name, :active, :created_at, :updated_at
json.url main_app.company_url(company, format: :json)
