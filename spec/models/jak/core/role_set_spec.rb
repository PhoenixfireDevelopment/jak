# frozen_string_literal: true

require 'rails_helper'

module Jak
  RSpec.describe Jak::Core::RoleSet, type: :model do
    describe 'concerning required attributes' do
      let(:valid_payload) { [{ klass: 'User', namespace: 'dummy', constraints: %i[manage] }] }

      it 'requires the role_name' do
        expect { described_class.new(nil, valid_payload) }.to raise_error(ArgumentError, 'Role Name is required!')
      end

      it 'requires the spine' do
        expect { described_class.new('rspec', []) }.to raise_error(ArgumentError, 'Spine is required!')
      end

      # klass / constraints / namespace should all be required!
      it 'rejects missing hash keys from spine arguments' do
        expect { described_class.new('rspec', [{}]) }.to raise_error('Invalid RoleSet Payload!')
      end
    end

    describe 'constants' do
      it 'knows MANDATORY_KEYS' do
        expect(::Jak::Core::RoleSet::MANDATORY_KEYS).to match_array(%i[klass namespace constraints])
      end
    end
  end
end
