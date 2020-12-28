# frozen_string_literal: true

require 'rails_helper'

module Jak
  RSpec.describe Jak::Core::NamespaceManager, type: :model do
    let(:namespace_manager) { Jak.namespace_manager }

    before(:each) do
      Jak.namespace_manager.send(:clear!)
    end

    describe 'concerning attributes' do
      it 'knows the default namespaces' do
        expect(namespace_manager.to_a).to match_array([])
      end
    end

    describe 'block configuration' do
      before(:each) do
        # Only populate this once!
        Jak.configure do |config|
          config.dsl do
            create_namespace('frontend') do
            end
          end
        end
      end

      it 'can use the define method in a block' do
        expect(namespace_manager.find('frontend')).to_not be_nil
      end

      it 'knows the names of the managed_scopes' do
        expect(namespace_manager.namespace_names).to match_array(['frontend'])
      end
    end
  end
end
