# frozen_string_literal: true

require 'rails_helper'

module Jak
  RSpec.describe Jak::Core::ConstraintManager, type: :model do
    let(:constraint_manager) { Jak.constraint_manager }
    let(:constraint) do
      constraint = Jak::Core::Constraint.new('rspec')
      constraint.klass 'User'
      constraint.i18n false
      constraint.actions %i[show]
      constraint.restrict :id
      constraint
    end

    # Reset the engine every time
    before(:each) do
      Jak.constraint_manager.send(:clear!)
    end

    # Is this right?
    describe 'concerning defaults' do
      it '.to_a returns an empty list' do
        expect(constraint_manager.to_a).to match_array([])
      end
    end

    # Register
    describe '.register' do
      it 'adds a key for the name of the constraint class' do
        expect do
          constraint_manager.register(constraint)
        end.to change(constraint_manager.constraints, :keys).from([]).to([User])
      end

      it 'adds a new constraint' do
        constraint_manager.register(constraint)
        expect(constraint_manager.constraints[constraint.my_klass.constantize][constraint.my_namespace]).to eql(constraint)
      end

      it 'does not add a new constraint if it already exists' do
        allow(constraint_manager).to receive(:constraints).and_return(User => { 'rspec' => constraint })
        expect do
          constraint_manager.register(constraint)
        end.to_not change(constraint_manager.constraints, :keys)
      end
    end

    # Find
    describe '.find' do
      it 'finds a constraint which exists' do
        allow(constraint_manager).to receive(:constraints).and_return(User => { 'rspec' => constraint })
        allow(constraint_manager.constraints).to receive(:[]).with(User).and_return('rspec' => constraint)
        allow(constraint_manager.constraints[User]).to receive(:[]).with('rspec').and_return(constraint)

        expect(constraint_manager.find(constraint.my_namespace, constraint.my_klass)).to eql(constraint)
      end

      it 'returns nil if my_namespace is omitted' do
        expect(constraint_manager.find(nil, constraint.my_klass)).to be_nil
      end

      it 'returns nil if my_klass is omitted' do
        expect(constraint_manager.find(constraint.my_namespace, nil)).to be_nil
      end

      it 'returns nil when it is not found' do
        expect(constraint_manager.find('bogus', constraint.my_klass)).to be_nil
      end
    end

    # Remove
    describe '.remove' do
      it 'removes a constraint which exists' do
        # Add the constraint
        constraint_manager.register(constraint)

        expect do
          constraint_manager.remove('rspec', 'User')
        end.to change(constraint_manager.constraints[User], :keys).from(['rspec']).to([])
      end

      it 'returns nil when it tries to remove a non-existent constraint' do
        constraint_manager.remove('bogus', 'User')
      end
    end

    # Each
    describe '.each' do
      it 'can iterate over all the constraints' do
        constraint_manager.register(constraint)

        array = []

        constraint_manager.each { |_klass, hash| array.push(hash.keys) }
        expect(array.flatten).to match_array(['rspec'])
      end
    end

    # Count
    describe '.count' do
      before(:each) do
        constraint_manager.register(constraint)
      end

      it 'returns a count of all the constraints' do
        expect(constraint_manager.count(nil)).to eql(1)
      end

      it 'counts the number of constraints for a given class' do
        expect(constraint_manager.count('User')).to eql(1)
      end

      it 'returns nil if it does not exist' do
        expect(constraint_manager.count('Lead')).to be_nil
      end
    end

    # .clear!
    describe '.clear!' do
      before(:each) do
        constraint_manager.register(constraint)
      end

      it 'can clear out the whole thing' do
        expect do
          constraint_manager.send(:clear!)
        end.to change(constraint_manager, :constraints).to({})
      end
    end
  end
end
