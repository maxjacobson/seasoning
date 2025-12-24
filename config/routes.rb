Rails.app.routes.draw do
  root to: "magic_links#new"
  resource :signup, only: [:show, :create], controller: "signups"
  resource :login, only: [:show, :create], controller: "password_sessions"
  resource :password, only: [:edit, :update], controller: "passwords"
  resource :admin, only: [:show]
  resources :follows, only: [:create, :destroy]
  resources :returning_show_notifications, only: [:destroy]
  resource :credits, only: [:show]
  resource :roadmap, only: [:show]
  resource :changelog, only: [:show]
  resources :magic_links, only: [:create], path: "magic-links"
  resources :humans, only: [:create]
  resources :shows, only: [:index, :show], param: :slug do
    resource :your_show, only: [:create, :destroy, :update], path: "/relationship"
    resource :note_to_self, only: [:edit], path: "/note-to-self", controller: "notes_to_self"
    resource :refresh, only: [:create], controller: "refresh_show"
  end

  get "/shows/:show_slug/:season_slug/reviews/new", to: "season_reviews#new", as: :new_season_review
  post "/shows/:show_slug/:season_slug/reviews", to: "season_reviews#create", as: :season_reviews
  get "/shows/:show_slug/:season_slug", to: "seasons#show", as: :season
  post "/shows/:show_slug/:season_slug/skipping", to: "season_skippings#create", as: :season_skipping
  delete "/shows/:show_slug/:season_slug/skipping", to: "season_skippings#destroy"
  post "/shows/:show_slug/:season_slug/episodes/:episode_number/viewing", to: "episode_viewings#create",
                                                                          as: :episode_viewing
  delete "/shows/:show_slug/:season_slug/episodes/:episode_number/viewing", to: "episode_viewings#destroy"
  get "/shows/:show_slug/:season_slug/:episode_number", to: "episodes#show", as: :episode
  resource :settings, only: [:show, :update]
  resources :importable_shows, only: [:create], path: "import-shows"
  resource :search, only: [:show]
  delete "/logout", to: "sessions#destroy", as: :logout
  get "/check-your-email", to: "check_your_email#show", as: :check_your_email
  get "/knock-knock/:token", to: "magic_links#show", as: :redeem_magic_link
  get "/:handle", to: "human_profiles#show", as: :human_profile
  scope "/:handle", as: "profile" do
    resources :reviews, only: [:index]
    resources :stats, only: [:index, :show], param: :year, constraints: { year: /\d{4}/ }
    get "shows/:show_slug/:season_slug/edit", to: "season_reviews#edit", as: :edit_season_review
    get "shows/:show_slug/:season_slug/:viewing/edit", to: "season_reviews#edit", as: :edit_season_review_viewing
    get "shows/:show_slug/:season_slug", to: "season_reviews#show", as: :season_review
    get "shows/:show_slug/:season_slug/:viewing", to: "season_reviews#show", as: :season_review_viewing
    patch "shows/:show_slug/:season_slug", to: "season_reviews#update"
    patch "shows/:show_slug/:season_slug/:viewing", to: "season_reviews#update"
    delete "shows/:show_slug/:season_slug", to: "season_reviews#destroy"
    delete "shows/:show_slug/:season_slug/:viewing", to: "season_reviews#destroy"
  end
end
