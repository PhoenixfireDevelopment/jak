# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Company, type: :model do
  describe 'concerning validations' do
    it 'has a valid factory' do
      expect(build(:company)).to be_valid
    end

    it 'requires the name' do
      expect(build(:company, name: nil)).to_not be_valid
    end

    it 'requires a unique name' do
      expect(create(:company, name: 'company')).to be_valid
      expect(build(:company, name: 'company')).to_not be_valid
    end

    it 'requires a unique name regardless of case' do
      expect(create(:company, name: 'company')).to be_valid
      expect(build(:company, name: 'COMPANY')).to_not be_valid
    end
  end

  describe 'concering associations' do
    let(:company) { create(:company) }

    it 'has many users' do
      user_1 = create(:user, company: company)
      user_2 = create(:user, company: company)
      expect(company.users).to match_array([user_1, user_2])
    end

    it 'has many roles' do
      role_1 = create(:role, company: company)
      role_2 = create(:role, company: company)
      expect(company.roles).to match_array([role_1, role_2])
    end
  end

  describe 'concerning ActiveRecord callbacks' do
    let(:company) { create(:company) }

    it 'nukes the users' do
      user = create(:user, company: company)
      company.destroy
      expect { user.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'nukes the roles' do
      role = create(:role, company: company)
      company.destroy
      expect { role.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
