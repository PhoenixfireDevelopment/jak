# frozen_string_literal: true

require 'rails_helper'

module Jak
  RSpec.describe Jak, type: :model do
    context 'versioning' do
      it 'knows the semantic VERSION number' do
        expect(Jak::VERSION).to eql('0.0.1')
      end
    end

    # configuration
    context 'Gem Configuration' do
      # C/Klass stuff
      it 'has a role_class method' do
        expect(Jak.role_class).to_not be_nil
        expect(Jak.role_klass).to eq(Role)
      end

      it 'has a user_class method' do
        expect(Jak.user_class).to_not be_nil
        expect(Jak.user_klass).to eq(User)
      end

      it 'has a user_ability_class method' do
        expect(Jak.user_ability_class).to_not be_nil
        expect(Jak.user_ability_klass).to eq(Ability)
      end

      it 'has a tenant_class method' do
        expect(Jak.tenant_class).to_not be_nil
        expect(Jak.tenant_klass).to eq(::Company)
      end

      it 'has a power_class method' do
        expect(Jak.power_class).to eql('Jak::Power')
        expect(Jak.power_klass).to eql(Jak::Power)
      end

      # Module attributes:

      it 'has a configurable default_actions' do
        expect(Jak.default_actions).to_not be_nil
        expect(Jak.default_actions).to eq(%i[manage index show create update destroy])
      end

      it 'knows the roles_foreign_key' do
        expect(Jak.roles_foreign_key).to eql('company_id')
      end

      it 'knows the tenant_id_column' do
        expect(Jak.tenant_id_column).to eql('company')
      end

      it 'default the invokers to an empty set' do
        expect(Jak.invokers.to_a).to match_array([User, Lead])
      end

      it 'knows the dsl_profile_path' do
        expect(Jak.dsl_profile_path).to_not be_nil
        expect(Jak.dsl_profile_path).to eql('/app/src/spec/support/dsl/test1')
      end
    end

    describe 'singletons' do
      it 'has a namespace_manager' do
        expect(Jak.namespace_manager).to eql(Jak::Core::NamespaceManager.instance)
      end

      it 'has a Roleset' do
        expect(Jak.rolesets).to eql(Jak::Core::Rolesets.instance)
      end

      it 'has a constraint_manager' do
        expect(Jak.constraint_manager).to eql(Jak::Core::ConstraintManager.instance)
      end
    end

    context '.clear!' do
      it 'clears the invokers list' do
        expect(Jak.invokers).to receive(:clear)
        Jak.clear!
      end

      it 'clears the constraint_manager' do
        expect(Jak.constraint_manager).to receive(:clear!)
        Jak.clear!
      end

      it 'clears the namespace_manager' do
        expect(Jak.namespace_manager).to receive(:clear!)
        Jak.clear!
      end

      it 'clears the rolesets' do
        expect(Jak.rolesets).to receive(:clear!)
        Jak.clear!
      end
    end

    context '.dsl' do
      it 'responds to the method' do
        expect(Jak.respond_to?(:dsl)).to be_truthy
      end

      it 'delegates off to the DSL module' do
        expect(Jak::Core::DSL).to receive(:define)
        Jak.dsl do
        end
      end
    end
  end
end
