# frozen_string_literal: true

Jak::Engine.routes.draw do
  resources :permissions, except: %i[new edit]
  root to: 'permissions#index'
end
