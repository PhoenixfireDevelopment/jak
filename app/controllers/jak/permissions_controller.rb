# frozen_string_literal: true

require_dependency 'jak/application_controller'

# The Jak module
module Jak
  # The Permissions Controller
  class PermissionsController < ApplicationController
    before_action :load_resource, only: %i[show update destroy]

    # GET /permissions
    def index
      @permissions = Permission.all
    end

    # GET /permissions/1
    def show; end

    # POST /permissions
    def create
      @permission = Permission.new(safe_params)

      if @permission.save
        render :show, status: :created, location: @permission
      else
        render json: @permission.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /permissions/1
    def update
      if @permission.update(safe_params)
        render :show, status: :ok, location: @permission
      else
        render json: @permission.errors, status: :unprocessable_entity
      end
    end

    # DELETE /permissions/1
    def destroy
      @permission.destroy
      head :no_content
    end

    private

    def load_resource
      @permission = Permission.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def safe_params
      params.require(:permission).permit(:action, :klass, :description, :namespace, :restricted)
    end
  end
end
