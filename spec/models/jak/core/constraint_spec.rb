# frozen_string_literal: true

require 'rails_helper'

module Jak
  RSpec.describe Jak::Core::Constraint, type: :model do
    describe '.initialize validations' do
      it 'requires the namespace' do
        expect { described_class.new(nil) }.to raise_error(ArgumentError, '`namespace` is required!')
      end

      it 'defaults my_actions to the defaults from Jak' do
        expect(described_class.new('rspec').my_actions).to match_array(::Jak.default_actions)
      end
    end

    describe 'dsl' do
      subject(:subject) { described_class.new('rspec') }

      context '.klass' do
        it 'sets my_klass variable' do
          expect do
            subject.klass('Company')
          end.to change(subject, :my_klass).from(nil).to('Company')
        end

        it 'raises ArgumentError if it is nil' do
          expect do
            subject.klass(nil)
          end.to raise_error(ArgumentError, '`klass` cannot be nil!')
        end

        it 'raises ArgumentError if the type is not a String' do
          expect do
            subject.klass(:company)
          end.to raise_error(ArgumentError, '`klass` must be a String!')
        end
      end

      context '.namespace' do
        it 'sets the my_namespace variable' do
          expect do
            subject.namespace('rspec-dummy')
          end.to change(subject, :my_namespace).from('rspec').to('rspec-dummy')
        end

        it 'raises ArgumentError if it is nil' do
          expect do
            subject.namespace(nil)
          end.to raise_error(ArgumentError, '`namespace` cannot be nil!')
        end

        it 'raises ArgumentError if the type is not a String' do
          expect do
            subject.namespace(:rspec)
          end.to raise_error(ArgumentError, '`namespace` must be a String!')
        end
      end

      context '.i18n' do
        it 'sets my_i18n variable to false' do
          expect do
            subject.i18n(false)
          end.to change(subject, :my_i18n).from(nil).to(false)
        end

        it 'sets my_i18n variable to true' do
          expect do
            subject.i18n(true)
          end.to change(subject, :my_i18n).from(nil).to(true)
        end

        it 'raises ArgumentError when the value is not a boolean' do
          expect do
            subject.i18n(1)
          end.to raise_error(ArgumentError, '`i18n` must be a Boolean!')
        end
      end

      context '.mongo_permission_ids' do
        it 'sets the my_mongo_permission_ids variable' do
          expect do
            subject.mongo_permission_ids([123, 456])
          end.to change(subject, :my_mongo_permission_ids).from(nil).to([123, 456])
        end

        it 'raises ArgumentError when the value is not an Array' do
          expect do
            subject.mongo_permission_ids({})
          end.to raise_error(ArgumentError, '`mongo_permission_ids` must be an Array!')
        end
      end

      context '.actions' do
        it 'sets the my_actions variable' do
          expect do
            subject.actions(%i[index show])
          end.to change(subject, :my_actions).from(::Jak.default_actions).to(%i[index show])
        end

        it 'raises ArgumentError when the value is not an Array' do
          expect do
            subject.actions({})
          end.to raise_error(ArgumentError, '`actions` must be an Array!')
        end
      end

      context '.restrict' do
        it 'sets my_restrictions variable' do
          expect do
            subject.restrict(:id)
          end.to change(subject, :my_restrictions).from(nil).to(:id)
        end

        it 'raises ArgumentError if it is nil' do
          expect do
            subject.restrict(nil)
          end.to raise_error(ArgumentError, '`restrict` cannot be nil!')
        end

        it 'raises ArgumentError if the type is not a Symbol' do
          expect do
            subject.restrict('rspec')
          end.to raise_error(ArgumentError, '`restrict` must be a Symbol!')
        end
      end
    end
  end
end
