# frozen_string_literal: true

json.extract! lead, :id, :name, :assignable_id, :created_at, :updated_at
json.url main_app.company_lead_url(lead.company, lead, format: :json)
