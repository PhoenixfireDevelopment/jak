# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:company) { create(:company) }

  # This should return the minimal set of attributes required to create a valid
  # User. As you add validations to User, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    attributes_for(:user).merge(company_id: company.id)
  end

  let(:invalid_attributes) do
    {
      name: nil
    }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # UsersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'returns a success response' do
      user = User.create! valid_attributes
      get :index, params: { company_id: company.to_param, format: :json }, session: valid_session
      expect(response).to be_successful
      expect(assigns(:users)).to eq([user])
      expect(assigns(:company)).to eq(company)
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      user = User.create! valid_attributes
      get :show, params: { company_id: company.to_param, id: user.to_param, format: :json }, session: valid_session
      expect(response).to be_successful
      expect(assigns(:user)).to eql(user)
      expect(assigns(:company)).to eql(company)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new User' do
        expect do
          post :create, params: { company_id: company.to_param, user: valid_attributes, format: :json }, session: valid_session
        end.to change(User, :count).by(1)
      end

      it 'renders a JSON response with the new user' do
        post :create, params: { company_id: company.to_param, user: valid_attributes, format: :json }, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(company_user_url(company, User.last))
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new user' do
        post :create, params: { company_id: company.to_param, user: invalid_attributes, format: :json }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        {
          name: 'Mark Holmberg'
        }
      end

      it 'updates the requested user' do
        user = User.create! valid_attributes
        put :update, params: { company_id: company.to_param, id: user.to_param, user: new_attributes, format: :json }, session: valid_session
        user.reload
        expect(user.name).to eql('Mark Holmberg')
      end

      it 'renders a JSON response with the user' do
        user = User.create! valid_attributes

        put :update, params: { company_id: company.to_param, id: user.to_param, user: valid_attributes, format: :json }, session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the user' do
        user = User.create! valid_attributes

        put :update, params: { company_id: company.to_param, id: user.to_param, user: invalid_attributes, format: :json }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested user' do
      user = User.create! valid_attributes
      expect do
        delete :destroy, params: { company_id: company.to_param, id: user.to_param, format: :json }, session: valid_session
      end.to change(User, :count).by(-1)
    end
  end
end
