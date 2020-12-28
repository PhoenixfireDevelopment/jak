# frozen_string_literal: true

require 'rails_helper'

module Jak
  RSpec.describe Grant, type: :model do
    describe 'concerning validations' do
      it 'has a valid factory' do
        expect(build(:jak_grant)).to be_valid
      end

      it 'requires the permission' do
        expect(build(:jak_grant, permission: nil)).to_not be_valid
      end
    end
  end
end
