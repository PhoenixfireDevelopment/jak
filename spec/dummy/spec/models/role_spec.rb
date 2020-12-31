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

    describe 'concerning .permission_ids/1' do
      before(:each) do
        @role = create(:role, name: 'Sales Representative')
        @permissions = Jak::Permission.all.limit(2).to_a
        @ids = @permissions.map { |k| k._id.to_s }
        @role.permission_ids = @ids
        @role.save
      end

      it 'assigns some random permissions for the test' do
        expect(@role.permissions(true)).to_not be_empty
      end

      it 'can remove just the last permission' do
        expect do
          @role.permission_ids = [@ids.first]
          @role.save
        end.to change { @role.permissions(true) }.from(@permissions).to([@permissions.first])
      end

      it 'can remove just the first permission' do
        expect do
          @role.permission_ids = [@ids.last]
          @role.save
        end.to change { @role.permissions(true) }.from(@permissions).to([@permissions.last])
      end

      it 'can remove all permissions with an empty array' do
        expect do
          @role.permission_ids = []
          @role.save
        end.to change { @role.permissions(true) }.from(@permissions).to([])
      end
    end
  end
end
