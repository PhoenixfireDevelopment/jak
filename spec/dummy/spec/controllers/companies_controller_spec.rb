# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CompaniesController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # Company. As you add validations to Company, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    attributes_for(:company)
  end

  let(:invalid_attributes) do
    {
      name: nil
    }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CompaniesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'returns a success response' do
      company = Company.create! valid_attributes
      get :index, params: { format: :json }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      company = Company.create! valid_attributes
      get :show, params: { id: company.to_param, format: :json }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Company' do
        expect do
          post :create, params: { company: valid_attributes, format: :json }, session: valid_session
        end.to change(Company, :count).by(1)
      end

      it 'renders a JSON response with the new company' do
        post :create, params: { company: valid_attributes, format: :json }, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(company_url(Company.last))
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new company' do
        post :create, params: { company: invalid_attributes, format: :json }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        {
          name: 'Blackwing Development'
        }
      end

      it 'updates the requested company' do
        company = Company.create! valid_attributes
        put :update, params: { id: company.to_param, company: new_attributes, format: :json }, session: valid_session
        company.reload
        expect(company.name).to eql('Blackwing Development')
      end

      it 'renders a JSON response with the company' do
        company = Company.create! valid_attributes

        put :update, params: { id: company.to_param, company: valid_attributes, format: :json }, session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the company' do
        company = Company.create! valid_attributes

        put :update, params: { id: company.to_param, company: invalid_attributes, format: :json }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested company' do
      company = Company.create! valid_attributes
      expect do
        delete :destroy, params: { id: company.to_param, format: :json }, session: valid_session
      end.to change(Company, :count).by(-1)
    end
  end
end
