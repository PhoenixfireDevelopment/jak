# frozen_string_literal: true

FactoryBot.define do
  factory :role, class: 'Role' do
    sequence(:name) { |k| "Role-#{k}" }
    company { |i| i.association(:company) }
  end

  factory :sales_representative, parent: :role do
    name { 'Sales Representative' }
    key { 'sales-representative' }
  end

  factory :sales_manager, parent: :role do
    name { 'Sales Manager' }
    key { 'sales-manager' }
  end
end
