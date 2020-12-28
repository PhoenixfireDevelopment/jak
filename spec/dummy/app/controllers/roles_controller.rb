# frozen_string_literal: true

# Dummy Roles Controller
class RolesController < ApplicationController
  before_action :load_company
  before_action :load_resource, only: %i[show update destroy]

  # GET /roles
  def index
    @roles = @company.roles.ordered
  end

  # GET /roles/1
  def show; end

  # POST /roles
  def create
    @role = @company.roles.new(safe_params)

    if @role.save
      render :show, status: :created, location: [@company, @role]
    else
      render json: @role.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /roles/1
  def update
    if @role.update(safe_params)
      render :show, status: :ok, location: [@company, @role]
    else
      render json: @role.errors, status: :unprocessable_entity
    end
  end

  # DELETE /roles/1
  def destroy
    @role.destroy
    head :no_content
  end

  private

  def load_company
    @company = Company.find(params[:company_id])
  end

  def load_resource
    @role = @company.roles.find(params[:id])
  end

  def safe_params
    params.require(:role).permit(:name, :key)
  end
end
