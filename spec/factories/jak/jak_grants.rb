# frozen_string_literal: true

FactoryBot.define do
  factory :jak_grant, class: 'Jak::Grant' do
    permission { |i| i.association(:jak_permission) }
  end
end
