# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: 'User' do
    sequence(:name) { |k| "User-#{k}" }
    company { |i| i.association(:company) }
  end
end
