# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    defaults format: :json do
      resource :guest, only: [:show]
      resources :magic_links, only: %i[create show], path: "/magic-links"
      resources :humans, only: [:create]
      resources :your_shows, only: %i[index create update], path: "/your-shows"
      resources :your_seasons, only: %i[update], path: "/your-seasons"
      resources :profiles, only: [:show]
      resources :shows, only: %i[create index show] do
        resources :seasons, only: %i[show]
      end
      resource :settings, only: %i[show update]
      resources :follows, only: %i[create]
      resources :season_reviews, only: %i[create], path: "/season-reviews"
      resource :season_review, only: %i[show], path: "/season-review"
    end
  end

  get "/", to: "frontend#show", as: :root
  get "/*anything", to: "frontend#show"
end
