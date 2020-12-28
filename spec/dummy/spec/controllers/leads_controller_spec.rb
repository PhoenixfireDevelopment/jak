# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LeadsController, type: :controller do
  let(:company) { create(:company) }
  let(:assignable) { create(:user) }

  # This should return the minimal set of attributes required to create a valid
  # Lead. As you add validations to Lead, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    attributes_for(:lead).merge(company_id: company.id, assignable_id: assignable.id)
  end

  let(:invalid_attributes) do
    {
      name: nil
    }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # LeadsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'returns a success response' do
      lead = Lead.create! valid_attributes
      get :index, params: { company_id: company.to_param, format: :json }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      lead = Lead.create! valid_attributes
      get :show, params: { company_id: company.to_param, id: lead.to_param, format: :json }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Lead' do
        expect do
          post :create, params: { company_id: company.to_param, lead: valid_attributes, format: :json }, session: valid_session
        end.to change(Lead, :count).by(1)
      end

      it 'renders a JSON response with the new lead' do
        post :create, params: { company_id: company.to_param, lead: valid_attributes, format: :json }, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(company_lead_url(company, Lead.last))
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new lead' do
        post :create, params: { company_id: company.to_param, lead: invalid_attributes, format: :json }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        {
          name: 'Jak'
        }
      end

      it 'updates the requested lead' do
        lead = Lead.create! valid_attributes
        put :update, params: { company_id: company.to_param, id: lead.to_param, lead: new_attributes, format: :json }, session: valid_session
        lead.reload
        expect(lead.name).to eql('Jak')
      end

      it 'renders a JSON response with the lead' do
        lead = Lead.create! valid_attributes

        put :update, params: { company_id: company.to_param, id: lead.to_param, lead: valid_attributes, format: :json }, session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the lead' do
        lead = Lead.create! valid_attributes

        put :update, params: { company_id: company.to_param, id: lead.to_param, lead: invalid_attributes, format: :json }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested lead' do
      lead = Lead.create! valid_attributes
      expect do
        delete :destroy, params: { company_id: company.to_param, id: lead.to_param, format: :json }, session: valid_session
      end.to change(Lead, :count).by(-1)
    end
  end
end
