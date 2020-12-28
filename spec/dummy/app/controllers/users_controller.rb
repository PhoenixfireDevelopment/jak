# frozen_string_literal: true

# Dummy Users Controller
class UsersController < ApplicationController
  before_action :load_company
  before_action :load_resource, only: %i[show update destroy]

  # GET /users
  def index
    @users = @company.users.ordered
  end

  # GET /users/1
  def show; end

  # POST /users
  def create
    @user = @company.users.new(safe_params)

    if @user.save
      render :show, status: :created, location: [@company, @user]
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(safe_params)
      render :show, status: :ok, location: [@company, @user]
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    head :no_content
  end

  private

  def load_company
    @company = Company.find(params[:company_id])
  end

  def load_resource
    @user = @company.users.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def safe_params
    params.require(:user).permit(:name)
  end
end
