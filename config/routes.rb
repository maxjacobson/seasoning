# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    defaults format: :json do
      resource :guest, only: [:show]
      resources :magic_links, only: %i[create show], path: "/magic-links"
      resources :humans, only: [:create]
    end
  end

  get "/", to: "frontend#show"
  get "/*anything", to: "frontend#show"
end
