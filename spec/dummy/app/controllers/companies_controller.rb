# frozen_string_literal: true

# Dummy Companies Controller
class CompaniesController < ApplicationController
  before_action :load_resource, only: %i[show update destroy]

  # GET /companies
  def index
    @companies = Company.ordered
  end

  # GET /companies/1
  def show; end

  # POST /companies
  def create
    @company = Company.new(safe_params)

    if @company.save
      render :show, status: :created, location: @company
    else
      render json: @company.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /companies/1
  def update
    if @company.update(safe_params)
      render :show, status: :ok, location: @company
    else
      render json: @company.errors, status: :unprocessable_entity
    end
  end

  # DELETE /companies/1
  def destroy
    @company.destroy
    head :no_content
  end

  private

  def load_resource
    @company = Company.find(params[:id])
  end

  def safe_params
    params.require(:company).permit(:name, :active)
  end
end
