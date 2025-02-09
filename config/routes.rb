Rails.application.routes.draw do
  namespace :api do
    defaults format: :json do
      resource :guest, only: [:show]
      resources :magic_links, only: [:create, :show], path: "/magic-links"
      resources :humans, only: [:create]
      resources :your_shows, only: [:index, :create, :update, :destroy], path: "/your-shows"
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
      resources :imports, only: [:index, :create]
      resource :settings, only: [:show, :update]
      resources :follows, only: [:create]
      resources :season_reviews, only: [:create, :index], path: "/season-reviews"
      resource :season_review, only: [:show, :destroy], path: "/season-review"
      resource :admin, only: [:show]
      resource :human_limits, only: [:show], path: "/human-limits", controller: "human_limits"
    end
  end

  get "/", to: "frontend#show", as: :root
  get "/*anything", to: "frontend#show"
end
