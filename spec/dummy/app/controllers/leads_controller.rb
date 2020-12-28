# frozen_string_literal: true

# Dummy Leads Controller
class LeadsController < ApplicationController
  before_action :load_company
  before_action :load_resource, only: %i[show update destroy]

  # GET /leads
  def index
    @leads = @company.leads.ordered
  end

  # GET /leads/1
  def show; end

  # POST /leads
  def create
    @lead = @company.leads.new(safe_params)

    if @lead.save
      render :show, status: :created, location: [@company, @lead]
    else
      render json: @lead.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /leads/1
  def update
    if @lead.update(safe_params)
      render :show, status: :ok, location: [@company, @lead]
    else
      render json: @lead.errors, status: :unprocessable_entity
    end
  end

  # DELETE /leads/1
  def destroy
    @lead.destroy
    head :no_content
  end

  private

  def load_company
    @company = Company.find(params[:company_id])
  end

  def load_resource
    @lead = @company.leads.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def safe_params
    params.require(:lead).permit(:name, :assignable_id)
  end
end
