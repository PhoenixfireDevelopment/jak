# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'concerning validations' do
    it 'has a valid factory' do
      expect(build(:user)).to be_valid
    end

    it 'requires the company' do
      expect(build(:user, company: nil)).to_not be_valid
      expect(build(:user, company_id: nil)).to_not be_valid
    end

    it 'requires the name' do
      expect(build(:user, name: nil)).to_not be_valid
    end

    it 'requires a unique name' do
      expect(create(:user, name: 'user')).to be_valid
      expect(build(:user, name: 'user')).to_not be_valid
    end

    it 'requires a unique name regardless of case' do
      expect(create(:user, name: 'user')).to be_valid
      expect(build(:user, name: 'USER')).to_not be_valid
    end
  end
end
