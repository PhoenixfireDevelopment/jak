# frozen_string_literal: true

namespace :jak do
  desc 'Create Sample Companies'
  task seed_companies: :environment do
    (1..5).each do |k|
      ::Company.create!(name: "Company-#{k}", active: [true, false].sample)
    end
  end

  desc 'Create Sample Users for first company'
  task seed_users: :environment do
    (1..10).each do |k|
      ::User.create!(name: "Username-#{k}", company: ::Company.first)
    end
  end

  desc 'Create Sample Leads for first company'
  task seed_leads: :environment do
    user_ids = ::Company.first.users.pluck(:id)
    (1..50).each do |k|
      ::Lead.create!(name: "Lead-#{k}", company: ::Company.first, assignable_id: user_ids.sample)
    end
  end
end
