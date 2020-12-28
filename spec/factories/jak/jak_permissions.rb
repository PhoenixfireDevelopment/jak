# frozen_string_literal: true

FactoryBot.define do
  factory :jak_permission, class: 'Jak::Permission' do
    action { %i[manage index show new create edit update destroy].sample }
    klass { %w[Company User Role].sample }
    description { 'Some permission' }
    namespace { %w[frontend backend api rspec test_unit].sample }
    restricted { [true, false].sample }
  end
end
