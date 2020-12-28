# frozen_string_literal: true

# https://github.com/CanCanCommunity/cancancan/blob/develop/docs/Checking-Abilities.md#checking-with-class
# > Important: If a block or hash of conditions exist they will be ignored when checking on a class, and it will return true. For example:
# > can :read, Project, :priority => 3
# > can? :read, Project # returns true

require 'rails_helper'

# Testing a User's Ability
RSpec.describe ::Ability, type: :model do
  let(:company) { create(:company, name: 'R-Spec') }
  let(:user) { create(:user, company: company) }
  let(:namespace) { Jak.namespace_manager.find('rspec') }

  before(:each) do
    stub_const('::Ability::NAMESPACES_TO_YIELD', %w[rspec])
  end

  describe 'concerning validations' do
    it 'only yields the test scopes' do
      expect(Jak.namespace_manager.namespace_names).to match_array(%w[rspec])
    end

    it 'allows for hard-coded ability definitions' do
      expect(user.can?(:index, :dashboard)).to be_truthy
    end

    context 'namespaces and scoped_to_tenant_id' do
      it 'sets scoped_to_tenant_id to true on the scope' do
        expect(namespace.scoped_to_tenant_id).to be_truthy
      end

      it 'knows that by the helper method scoped_to_tenant?' do
        expect(namespace.scoped_to_tenant?).to be_truthy
      end

      it 'knows that by the helper method scoped_to_tenant?' do
        expect(namespace.scoped_to_tenant?).to be_truthy
      end
    end

    context 'user permissions when they have a role assigned to them' do
      before(:each) do
        @company_1 = create(:company, name: 'Company 1')
        @company_2 = create(:company, name: 'Company 2')

        @user_1 = create(:user, company: @company_1)
        @user_2 = create(:user, company: @company_1)
        @user_3 = create(:user, company: @company_2)

        @company_1.create_default_roles
        @company_2.create_default_roles

        # Give Roles
        @role_1 = @company_1.roles.get('sales-representative')
        @user_1.roles << @role_1
        @user_2.roles << @role_1

        # Roles are scoped to the company_id
        @role_2 = @company_2.roles.get('sales-representative')
        @user_3.roles << @role_2
      end

      it 'ensures user_1 has the right role' do
        expect(@user_1.roles).to match_array([@role_1])
      end

      it 'ensures user_2 has the right role' do
        expect(@user_2.roles).to match_array([@role_1])
      end

      it 'ensures user_3 has the right role' do
        expect(@user_3.roles).to match_array([@role_2])
      end

      # They don't have any roles
      it 'allows them to view their own User account' do
        expect(@user_1.can?(:show, @user_1)).to be_truthy
      end

      it 'prevents them from viewing other users in the same company' do
        expect(@user_1.can?(:show, @user_2)).to be_falsey
      end

      it 'prevents them from viewing other users in a different company' do
        expect(@user_1.can?(:show, @user_3)).to be_falsey
      end

      # CAUTION: You can't compare agains the CLASS itself with a list/block of conditions!
      # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/Checking-Abilities.md#checking-with-class
      it 'handles the User class itself' do
        expect(@user_1.can?(:show, User)).to be_truthy
      end
    end
  end
end
