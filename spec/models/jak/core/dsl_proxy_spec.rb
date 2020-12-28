# frozen_string_literal: true

# https://thoughtbot.com/blog/writing-a-domain-specific-language-in-ruby

require 'rails_helper'

module Jak
  RSpec.describe Jak::Core::DSLProxy, type: :model do
    subject(:subject) { described_class.new }

    describe 'responds_to' do
      it 'responds to .create_namespace' do
        expect(subject.respond_to?(:create_namespace)).to be_truthy
      end
    end

    describe '.create_namespace' do
      it 'requires a block to be passed to .create_namespace' do
        expect do
          subject.create_namespace('rspec')
        end.to raise_error(ArgumentError, '`create_namespace` requires a block argument!')
      end

      it 'requires the name argument' do
        expect do
          subject.create_namespace nil do
          end
        end.to raise_error(ArgumentError, '`create_namespace` requires a name!')
      end

      it 'stub @@lexical works with creating a valid namespace' do
        allow(::Jak::Core::DSL).to receive(:lexical).and_return([:define])

        subject.create_namespace('rspec') do
        end
      end

      it 'raises an error when invoked outside the proper context' do
        expect do
          subject.create_namespace('rspec') do
          end
        end.to raise_error(ArgumentError, '`create_namespace` must be called from `define`!')
      end

      it 'sets the @@lexical variable' do
        allow(::Jak::Core::DSL).to receive(:lexical).and_return([:define])
        dsl = subject.create_namespace 'foo' do
        end

        expect(dsl).to match_array([[:define], :create_namespace])
      end
    end
  end
end
