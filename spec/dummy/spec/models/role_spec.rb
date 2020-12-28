# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Role, type: :model do
  describe 'concerning validations' do
    it 'has a valid factory' do
      expect(build(:role)).to be_valid
    end

    it 'requires the company' do
      expect(build(:role, company: nil)).to_not be_valid
    end

    it 'requires the company_id' do
      expect(build(:role, company_id: nil)).to_not be_valid
    end

    it 'requires the name' do
      expect(build(:role, name: nil)).to_not be_valid
    end

    describe 'concerning unique names' do
      let(:company_1) { create(:company) }
      let(:company_2) { create(:company) }

      it 'requires a unique name' do
        expect(create(:role, name: 'role', company: company_1)).to be_valid
        expect(build(:role, name: 'role', company: company_1)).to_not be_valid
        expect(build(:role, name: 'role', company: company_2)).to be_valid
      end

      it 'requires a unique name regardless of case scoped to the company' do
        expect(create(:role, name: 'role', company: company_1)).to be_valid
        expect(build(:role, name: 'ROLE', company: company_1)).to_not be_valid
        expect(build(:role, name: 'ROLE', company: company_2)).to be_valid
      end
    end
  end
end
