Rails.application.routes.draw do
  namespace :api do
    defaults format: :json do
      resource :guest, only: [:show]
      resources :your_shows, only: [:create, :update, :destroy], path: "/your-shows"
      resources :your_seasons, only: [:update], path: "/your-seasons" do
        resources :episodes, only: [:update], controller: "your_episodes"
      end
      resources :profiles, only: [:show] do
        resources :season_reviews, only: [:index], controller: "profile_season_reviews", path: "season-reviews"
        resources :followers, only: [:index], controller: "profile_followers", path: "followers"
        resources :follows, only: [:index], controller: "profile_follows", path: "following"
      end
      resources :shows, only: [:index, :show] do
        resources :seasons, only: [:show] do
          resources :episodes, only: [:show]
        end
      end
      resources :follows, only: [:create]
      resources :season_reviews, only: [:create], path: "/season-reviews"
      resource :season_review, only: [:show, :destroy], path: "/season-review"
      resource :human_limits, only: [:show], path: "/human-limits", controller: "human_limits"
    end
  end

  root to: "magic_links#new"
  resource :admin, only: [:show]
  resource :credits, only: [:show]
  resource :roadmap, only: [:show]
  resource :changelog, only: [:show]
  resources :magic_links, only: [:create], path: "magic-links"
  resources :humans, only: [:create]
  resources :shows, only: [:index]
  resource :settings, only: [:show, :update]
  resources :importable_shows, only: [:index, :create], path: "import-shows"
  resource :search, only: [:show]
  get "/logout", to: "sessions#destroy", as: :logout
  get "/check-your-email", to: "check_your_email#show", as: :check_your_email
  get "/knock-knock/:token", to: "magic_links#show", as: :redeem_magic_link
  get "/*anything", to: "frontend#show"
end
