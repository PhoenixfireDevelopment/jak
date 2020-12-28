# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RolesController, type: :controller do
  let(:company) { create(:company) }

  # This should return the minimal set of attributes required to create a valid
  # Role. As you add validations to Role, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    attributes_for(:role).merge(company_id: company.id)
  end

  let(:invalid_attributes) do
    {
      name: nil,
      key: nil
    }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # RolesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'returns a success response' do
      role = Role.create! valid_attributes
      get :index, params: { company_id: company.to_param, format: :json }, session: valid_session
      expect(response).to be_successful
      expect(assigns(:company)).to eql(company)
      expect(assigns(:roles)).to match_array([role])
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      role = Role.create! valid_attributes
      get :show, params: { company_id: company.to_param, id: role.to_param, format: :json }, session: valid_session
      expect(response).to be_successful
      expect(assigns(:role)).to eql(role)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Role' do
        expect do
          post :create, params: { company_id: company.to_param, role: valid_attributes, format: :json }, session: valid_session
        end.to change(Role, :count).by(1)
      end

      it 'renders a JSON response with the new role' do
        post :create, params: { company_id: company.to_param, role: valid_attributes, format: :json }, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(company_role_url(company, Role.last))
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new role' do
        post :create, params: { company_id: company.to_param, role: invalid_attributes, format: :json }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        {
          name: 'My Role'
        }
      end

      it 'updates the requested role' do
        role = Role.create! valid_attributes
        put :update, params: { company_id: company.to_param, id: role.to_param, role: new_attributes, format: :json }, session: valid_session
        role.reload
        expect(role.name).to eql('My Role')
      end

      it 'renders a JSON response with the role' do
        role = Role.create! valid_attributes

        put :update, params: { company_id: company.to_param, id: role.to_param, role: valid_attributes, format: :json }, session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the role' do
        role = Role.create! valid_attributes

        put :update, params: { company_id: company.to_param, id: role.to_param, role: invalid_attributes, format: :json }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested role' do
      role = Role.create! valid_attributes
      expect do
        delete :destroy, params: { company_id: company.to_param, id: role.to_param, format: :json }, session: valid_session
      end.to change(Role, :count).by(-1)
    end
  end
end
