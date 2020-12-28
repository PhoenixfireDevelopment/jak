# frozen_string_literal: true

FactoryBot.define do
  factory :jak_power, class: 'Jak::Power' do
    transient do
      company { create(:company) }
    end

    user { create(:user, company: company) }
    role { create(:role, company: company) }
  end
end
