# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LeadsController, type: :routing do
  describe 'routing' do
    let(:url) { '/companies/5' }

    it 'routes to #index' do
      expect(get: "#{url}/leads").to route_to('leads#index', company_id: '5')
    end

    it 'routes to #show' do
      expect(get: "#{url}/leads/1").to route_to('leads#show', id: '1', company_id: '5')
    end

    it 'routes to #create' do
      expect(post: "#{url}/leads").to route_to('leads#create', company_id: '5')
    end

    it 'routes to #update via PUT' do
      expect(put: "#{url}/leads/1").to route_to('leads#update', id: '1', company_id: '5')
    end

    it 'routes to #update via PATCH' do
      expect(patch: "#{url}/leads/1").to route_to('leads#update', id: '1', company_id: '5')
    end

    it 'routes to #destroy' do
      expect(delete: "#{url}/leads/1").to route_to('leads#destroy', id: '1', company_id: '5')
    end
  end
end
