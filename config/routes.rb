Rails.application.routes.draw do
  root to: "magic_links#new"
  resource :admin, only: [:show]
  resources :follows, only: [:create, :destroy]
  resource :credits, only: [:show]
  resource :roadmap, only: [:show]
  resource :changelog, only: [:show]
  resources :magic_links, only: [:create], path: "magic-links"
  resources :humans, only: [:create]
  resources :shows, only: [:index, :show], param: :slug do
    resource :your_show, only: [:create, :destroy, :update], path: "/relationship"
    resource :note_to_self, only: [:edit], path: "/note-to-self", controller: "notes_to_self"
    resource :refresh, only: [:create], controller: "refresh_show"

    member do
      get "/:season_slug", to: "seasons#show", as: :season
      patch "/:season_slug", to: "seasons#update", as: :update_season
      get "/:season_slug/:episode_slug", to: "episodes#show", as: :season_episode
      get "/:season_slug/reviews/new", to: "season_reviews#new", as: :new_review
    end
  end
  resource :settings, only: [:show, :update]
  resources :importable_shows, only: [:index, :create], path: "import-shows"
  resource :search, only: [:show]
  delete "/logout", to: "sessions#destroy", as: :logout
  get "/check-your-email", to: "check_your_email#show", as: :check_your_email
  get "/knock-knock/:token", to: "magic_links#show", as: :redeem_magic_link
  get "/:handle", to: "human_profiles#show", as: :human_profile
  scope "/:handle", as: "profile" do
    resources :reviews, only: [:index]
    resources :followers, only: [:index]
    resources :followings, only: [:index], path: "following"
  end
end
