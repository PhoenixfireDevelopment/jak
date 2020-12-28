# frozen_string_literal: true

# https://thoughtbot.com/blog/writing-a-domain-specific-language-in-ruby

require 'rails_helper'

module Jak
  RSpec.describe Jak::Core::DSL, type: :model do
    describe '.define' do
      it 'responds to .define' do
        expect(described_class.respond_to?(:define)).to be_truthy
      end

      it 'requires a block to be passed to .define' do
        expect do
          described_class.define
        end.to raise_error(ArgumentError, '`define` requires a block argument!')
      end

      it 'sets the @@lexical variable' do
        dsl = described_class.define do
        end

        # This is because the last thing the .define block does it to pop off the array
        expect(dsl).to match_array([[], :define])
      end
    end

    describe '.lexical' do
      it 'responds to .lexical' do
        expect(described_class.respond_to?(:lexical)).to be_truthy
      end
    end

    describe '.lexical?/1' do
      it 'responds to .lexical?' do
        expect(described_class.respond_to?(:lexical?)).to be_truthy
      end
    end

    describe '.registry' do
      it 'responds to .registry' do
        expect(described_class.respond_to?(:registry)).to be_truthy
      end
    end
  end
end
