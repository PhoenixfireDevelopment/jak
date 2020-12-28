# frozen_string_literal: true

Rails.application.routes.draw do
  mount Jak::Engine => '/jak'

  # TODO: you need a way to give a user a role, via Powers join table.
  resources :companies do
    resources :leads
    resources :roles
    resources :users
  end
  root to: 'companies#index'
end
