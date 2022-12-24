# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    defaults format: :json do
      resource :guest, only: [:show]
      resources :magic_links, only: %i[create show], path: "/magic-links"
      resources :humans, only: [:create]
      resources :your_shows, only: %i[index create update], path: "/your-shows"
      resources :your_seasons, only: %i[update], path: "/your-seasons"
      resources :profiles, only: [:show] do
        resources :season_reviews, only: [:index], controller: "profile_season_reviews", path: "season-reviews"
        resources :followers, only: [:index], controller: "profile_followers", path: "followers"
        resources :follows, only: [:index], controller: "profile_follows", path: "following"
      end
      resources :shows, only: %i[index show] do
        resources :seasons, only: %i[show]
      end
      resources :imports, only: %i[index create]
      resource :settings, only: %i[show update]
      resources :follows, only: %i[create]
      resources :season_reviews, only: %i[create index], path: "/season-reviews"
      resource :season_review, only: %i[show destroy], path: "/season-review"
      resource :admin, only: %i[show]
    end
  end

  get "/", to: "frontend#show", as: :root
  get "/*anything", to: "frontend#show"
end
