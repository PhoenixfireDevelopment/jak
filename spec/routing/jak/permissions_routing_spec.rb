# frozen_string_literal: true

require 'rails_helper'

module Jak
  RSpec.describe PermissionsController, type: :routing do
    describe 'routing' do
      routes { Jak::Engine.routes }

      it 'routes to #index' do
        expect(get: '/permissions').to route_to('jak/permissions#index')
      end

      it 'routes to #show' do
        expect(get: '/permissions/1').to route_to('jak/permissions#show', id: '1')
      end

      it 'routes to #create' do
        expect(post: '/permissions').to route_to('jak/permissions#create')
      end

      it 'routes to #update via PUT' do
        expect(put: '/permissions/1').to route_to('jak/permissions#update', id: '1')
      end

      it 'routes to #update via PATCH' do
        expect(patch: '/permissions/1').to route_to('jak/permissions#update', id: '1')
      end

      it 'routes to #destroy' do
        expect(delete: '/permissions/1').to route_to('jak/permissions#destroy', id: '1')
      end
    end
  end
end
