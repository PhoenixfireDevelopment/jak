# frozen_string_literal: true

FactoryBot.define do
  factory :lead do
    sequence(:name) { |n| "Lead-#{n}" }
    assignable { |i| i.association(:user) }
    company { |i| i.association(:company) }
  end
end
