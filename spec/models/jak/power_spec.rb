# frozen_string_literal: true

require 'rails_helper'

module Jak
  RSpec.describe Power, type: :model do
    describe 'concerning validations' do
      it 'has a valid factory' do
        expect(build(:jak_power)).to be_valid
      end

      it 'requires a role_id' do
        expect(build(:jak_power, role_id: nil)).to_not be_valid
      end

      it 'requires a role' do
        expect(build(:jak_power, role: nil)).to_not be_valid
      end

      it 'requires a user_id' do
        expect(build(:jak_power, user_id: nil)).to_not be_valid
      end

      it 'requires a user' do
        expect(build(:jak_power, user: nil)).to_not be_valid
      end

      it 'prevents duplicates' do
        company = create(:company)
        role = create(:role, company: company)
        user = create(:user, company: company)
        expect(create(:jak_power, user: user, role: role)).to be_valid
        expect(build(:jak_power, user: user, role: role)).to_not be_valid
      end

      it 'prevents assigning roles to users in other companies' do
        company_1 = create(:company, name: 'R-Spec')
        company_2 = create(:company, name: 'TestUnit')

        role_1 = create(:role, name: 'Sales Representative', company: company_1)
        role_2 = create(:role, name: 'Sales Representative', company: company_2)

        user = create(:user, company: company_1)

        expect(build(:jak_power, user: user, role: role_2)).to_not be_valid
      end
    end

    describe 'concerning ActiveRecord callbacks' do
      before(:each) do
        company = create(:company)
        @role = create(:role, company: company)
        @user = create(:user, company: company)
        @power = create(:jak_power, user: @user, role: @role)
      end

      it 'is destroyed if the role is destroyed' do
        @role.destroy
        expect { @power.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'is destroyed if the user is destroyed' do
        @user.destroy
        expect { @power.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
