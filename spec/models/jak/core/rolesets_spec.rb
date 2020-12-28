# frozen_string_literal: true

require 'rails_helper'

module Jak
  RSpec.describe Jak::Core::Rolesets, type: :model do
    let(:rolesets) { ::Jak.rolesets }
    let(:valid_payload) { [{ klass: 'User', namespace: 'dummy', constraints: %i[manage] }] }

    # Reset the engine every time
    before(:each) do
      Jak.rolesets.send(:clear!)
    end

    describe 'concerning defaults' do
      it 'to_a returns an empty list' do
        expect(rolesets.to_a).to match_array([])
      end
    end

    describe 'create_roleset' do
      it 'adds an entry to the Set' do
        expect(rolesets.to_a).to be_empty

        rolesets.defaults do |default|
          default.create_roleset 'MicroManager', [{ klass: User, constraints: %i[show edit], only: true, restrict: false, namespace: 'dummy_manager' }]
        end

        expect(rolesets.include?('MicroManager')).to be_truthy
      end
    end

    describe 'find' do
      it 'returns nil when given a non-existent name' do
        expect(rolesets.find('NotFound')).to be_nil
      end

      it 'returns the entry when given an existing name' do
        role_set = Jak::Core::RoleSet.new('Existing', valid_payload)
        rolesets.add(role_set)
        expect(rolesets.find('Existing')).to eql(role_set)
      end
    end

    describe 'add' do
      it 'adds a new role_set if it does not already exist' do
        role_set = Jak::Core::RoleSet.new('Existing', valid_payload)
        expect do
          rolesets.add(role_set)
        end.to change(rolesets, :count).from(0).to(1)
      end

      it 'wont add a duplicate one' do
        role_set = Jak::Core::RoleSet.new('Existing', valid_payload)
        rolesets.add(role_set) # Add it the first time

        expect do
          rolesets.add(role_set) # Try to erroneously add it again
        end.to_not change(rolesets, :count)
      end
    end

    describe 'remove' do
      it 'removes an entry if that entry exists' do
        role_set = Jak::Core::RoleSet.new('Existing', valid_payload)
        rolesets.add(role_set) # Add it the first time

        expect do
          rolesets.remove(role_set)
        end.to change(rolesets, :count).from(1).to(0)
      end
    end
  end
end
