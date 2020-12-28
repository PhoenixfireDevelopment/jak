# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lead, type: :model do
  describe 'concerning validations' do
    it 'has a valid factory' do
      expect(build(:lead)).to be_valid
    end

    it 'requires the company' do
      expect(build(:lead, company: nil)).to_not be_valid
    end

    it 'requires the company_id' do
      expect(build(:lead, company_id: nil)).to_not be_valid
    end

    it 'requires the name' do
      expect(build(:lead, name: nil)).to_not be_valid
    end

    it 'requires a unique name' do
      expect(create(:lead, name: 'lead')).to be_valid
      expect(build(:lead, name: 'lead')).to_not be_valid
    end

    it 'requires a unique name regardless of case' do
      expect(create(:lead, name: 'lead')).to be_valid
      expect(build(:lead, name: 'LEAD')).to_not be_valid
    end
  end
end
