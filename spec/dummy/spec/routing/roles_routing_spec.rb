# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RolesController, type: :routing do
  describe 'routing' do
    let(:url) { '/companies/5' }

    it 'routes to #index' do
      expect(get: "#{url}/roles").to route_to('roles#index', company_id: '5')
    end

    it 'routes to #show' do
      expect(get: "#{url}/roles/1").to route_to('roles#show', id: '1', company_id: '5')
    end

    it 'routes to #create' do
      expect(post: "#{url}/roles").to route_to('roles#create', company_id: '5')
    end

    it 'routes to #update via PUT' do
      expect(put: "#{url}/roles/1").to route_to('roles#update', id: '1', company_id: '5')
    end

    it 'routes to #update via PATCH' do
      expect(patch: "#{url}/roles/1").to route_to('roles#update', id: '1', company_id: '5')
    end

    it 'routes to #destroy' do
      expect(delete: "#{url}/roles/1").to route_to('roles#destroy', id: '1', company_id: '5')
    end
  end
end
