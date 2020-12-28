# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :routing do
  describe 'routing' do
    let(:url) { '/companies/5' }

    it 'routes to #index' do
      expect(get: "#{url}/users").to route_to('users#index', company_id: '5')
    end

    it 'routes to #show' do
      expect(get: "#{url}/users/1").to route_to('users#show', id: '1', company_id: '5')
    end

    it 'routes to #create' do
      expect(post: "#{url}/users").to route_to('users#create', company_id: '5')
    end

    it 'routes to #update via PUT' do
      expect(put: "#{url}/users/1").to route_to('users#update', id: '1', company_id: '5')
    end

    it 'routes to #update via PATCH' do
      expect(patch: "#{url}/users/1").to route_to('users#update', id: '1', company_id: '5')
    end

    it 'routes to #destroy' do
      expect(delete: "#{url}/users/1").to route_to('users#destroy', id: '1', company_id: '5')
    end
  end
end
