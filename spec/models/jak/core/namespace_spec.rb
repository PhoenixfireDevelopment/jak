# frozen_string_literal: true

require 'rails_helper'

module Jak
  RSpec.describe Jak::Core::Namespace, type: :model do
    describe 'concerning validations' do
      it 'requires a name' do
        expect { described_class.new(nil) }.to raise_error(ArgumentError)
      end

      it 'can set scoped_to_tenant_id to true' do
        foo = described_class.new do |klass|
          klass.name = 'frontend'
          klass.scope_to_tenant true
        end
        expect(foo.scoped_to_tenant_id).to be_truthy
        expect(foo.name).to eql('frontend')
      end

      it 'can set scoped_to_tenant_id to false' do
        foo = described_class.new do |klass|
          klass.name = 'backend'
          klass.scope_to_tenant false
        end
        expect(foo.scoped_to_tenant_id).to be_falsey
        expect(foo.name).to eql('backend')
      end

      it 'complains about non-boolean values' do
        expect do
          described_class.new do |klass|
            klass.name = 'backend'
            klass.scope_to_tenant '0xDEADBEEF'
          end
        end.to raise_error(ArgumentError, 'Invalid value for: `scope_to_tenant`!')
      end
    end

    describe 'DSL configuration' do
      it 'can be configured via a block' do
        block_namespace = described_class.new do |klass|
          klass.name = 'block_scope'
          klass.scope_to_tenant false
        end

        expect(block_namespace.name).to eql('block_scope')
        expect(block_namespace.scoped_to_tenant_id).to be_falsey
      end
    end

    describe 'DSL .scope_to_tenant / .scoped_to_tenant?' do
      subject(:rspec_namespace) { described_class.new('rspec') }

      it 'responds_to .scope_to_tenant' do
        expect(rspec_namespace.respond_to?(:scope_to_tenant)).to be_truthy
      end

      it '.scoped_to_tenant? returns true if the variable is true' do
        rspec_namespace.scope_to_tenant(true)
        expect(rspec_namespace.scoped_to_tenant?).to be_truthy
      end

      it '.scoped_to_tenant? returns false if the variable is false' do
        rspec_namespace.scope_to_tenant(false)
        expect(rspec_namespace.scoped_to_tenant?).to be_falsey
      end
    end

    describe 'DSL .create_constraint' do
      subject(:rspec_namespace) { described_class.new('rspec') }

      it 'responds_to .create_constraint' do
        expect(rspec_namespace.respond_to?(:create_constraint)).to be_truthy
      end
    end

    describe '.namespace_invokers' do
      it 'lists the invokers for this namespace' do
      end
    end

    describe '.namespace_constraints' do
      subject(:rspec_namespace) { described_class.new('rspec') }

      it 'responds to the method' do
        expect(rspec_namespace.respond_to?(:namespace_constraints)).to be_truthy
      end

      it 'is not empty' do
        expect(rspec_namespace.namespace_constraints).to_not be_empty
      end

      it 'has a key in the registry for rspec' do
        expect(Jak::Core::DSL.registry.keys).to include('rspec')
      end
    end

    describe '.namespace_constraints_for_klass' do
    end
  end
end
