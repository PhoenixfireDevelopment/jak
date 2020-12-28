# frozen_string_literal: true

require 'rails_helper'

module Jak
  RSpec.describe PermissionsController, type: :controller do
    # Make sure to use the engine routes
    routes { Jak::Engine.routes }

    # This should return the minimal set of attributes required to create a valid
    # Permission. As you add validations to Permission, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) do
      attributes_for(:jak_permission)
    end

    let(:invalid_attributes) do
      {
        action: nil,
        klass: nil
      }
    end

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # PermissionsController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe 'GET #index' do
      it 'assigns all permissions as @permissions' do
        permission = Permission.create! valid_attributes
        get :index, params: { format: :json }, session: valid_session
        expect(response).to be_successful
      end
    end

    describe 'GET #show' do
      it 'assigns the requested permission as @permission' do
        permission = Permission.create! valid_attributes
        get :show, params: { id: permission.to_param, format: :json }, session: valid_session
        expect(response).to be_successful
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new Permission' do
          expect do
            post :create, params: { permission: valid_attributes, format: :json }, session: valid_session
          end.to change(Permission, :count).by(1)
        end

        it 'renders a JSON response with the new permission' do
          post :create, params: { permission: valid_attributes, format: :json }, session: valid_session
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq(permission_url(Permission.last))
        end
      end

      context 'with invalid params' do
        it 'renders a JSON response with errors for the new permission' do
          post :create, params: { permission: invalid_attributes, format: :json }, session: valid_session
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid params' do
        let(:new_attributes) do
          {
            description: 'Blackwing Development'
          }
        end

        it 'updates the requested permission' do
          permission = Permission.create! valid_attributes
          put :update, params: { id: permission.to_param, permission: new_attributes, format: :json }, session: valid_session
          permission.reload
          expect(permission.description).to eql('Blackwing Development')
        end

        it 'renders a JSON response with the permission' do
          permission = Permission.create! valid_attributes

          put :update, params: { id: permission.to_param, permission: valid_attributes, format: :json }, session: valid_session
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end
      end

      context 'with invalid params' do
        it 'renders a JSON response with errors for the permission' do
          permission = Permission.create! valid_attributes

          put :update, params: { id: permission.to_param, permission: invalid_attributes, format: :json }, session: valid_session
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested permission' do
        permission = Permission.create! valid_attributes
        expect do
          delete :destroy, params: { id: permission.to_param, format: :json }, session: valid_session
        end.to change(Permission, :count).by(-1)
      end
    end
  end
end
