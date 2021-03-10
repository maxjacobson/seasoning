# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    defaults format: :json do
      resource :guest, only: [:show]
    end
  end

  get "/", to: "frontend#show"
  get "/*anything", to: "frontend#show"
end
