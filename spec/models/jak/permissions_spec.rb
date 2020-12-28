# frozen_string_literal: true

require 'rails_helper'

module Jak
  RSpec.describe Permission, type: :model do
    describe 'concerning validations' do
      it 'should have a valid factory' do
        expect(build(:jak_permission)).to be_valid
      end

      it 'should require an action' do
        expect(build(:jak_permission, action: nil)).to_not be_valid
      end

      it 'should require a klass' do
        expect(build(:jak_permission, klass: nil)).to_not be_valid
      end

      it 'should require a description' do
        expect(build(:jak_permission, description: nil)).to_not be_valid
      end

      it 'should require namespace' do
        expect(build(:jak_permission, namespace: nil)).to_not be_valid
      end
    end
  end
end
