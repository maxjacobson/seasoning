# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_04_13_223132) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "my_show_status", ["might_watch", "currently_watching", "stopped_watching", "waiting_for_more", "finished", "next_up"]
  create_enum "visibility", ["anybody", "myself"]

  create_table "browser_sessions", force: :cascade do |t|
    t.string "token", null: false, comment: "A token that is kept in the session"
    t.bigint "human_id", null: false
    t.datetime "expires_at", precision: nil, null: false, comment: "The time at which we should stop honoring the token and force them to log in again"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["human_id"], name: "index_browser_sessions_on_human_id"
  end

  create_table "episodes", force: :cascade do |t|
    t.string "name", null: false, comment: "The episode's official name"
    t.string "still_path", comment: "TMDB path to a photo related to the episode"
    t.integer "tmdb_id", null: false, comment: "The episode's id on TMDB"
    t.integer "episode_number", null: false, comment: "The position of the episode in the season"
    t.bigint "season_id", null: false, comment: "Which season this episode is part of"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "air_date", comment: "What date did this episode first air?"
    t.index ["season_id", "episode_number"], name: "index_episodes_on_season_id_and_episode_number", unique: true
    t.index ["season_id"], name: "index_episodes_on_season_id"
    t.index ["tmdb_id"], name: "index_episodes_on_tmdb_id", unique: true
  end

  create_table "follows", force: :cascade do |t|
    t.bigint "follower_id", null: false, comment: "Who is the person doing the following"
    t.bigint "followee_id", null: false, comment: "Who is the person being followed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followee_id"], name: "index_follows_on_followee_id"
    t.index ["follower_id", "followee_id"], name: "index_follows_on_follower_id_and_followee_id", unique: true
    t.index ["follower_id"], name: "index_follows_on_follower_id"
  end

  create_table "humans", force: :cascade do |t|
    t.string "handle", null: false, comment: "The handle is the human's nickname, username, or whatever you want to call it"
    t.string "email", null: false, comment: "Their email. This is how they'll log in. No passwords. Just click a link in your email."
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "share_currently_watching", default: true, null: false, comment: "Whether or not to publicly display your currently watching list on the profile page"
    t.enum "default_review_visibility", default: "anybody", null: false, comment: "Lets people specify who they generally want to share their reviews with, to save them some clicking", enum_type: "visibility"
    t.boolean "admin", default: false, null: false, comment: "Gives humans some extra abilities to see things like the admin stats page"
    t.integer "currently_watching_limit", comment: "How many shows, at most, does this human want to watch at once?"
    t.index ["email"], name: "humans_email_unique", unique: true
    t.index ["handle"], name: "humans_handle_unique", unique: true
  end

  create_table "magic_links", force: :cascade do |t|
    t.string "email", null: false, comment: "The email address that the magic link is sent to. Following the link proves they are this human."
    t.string "token", null: false, comment: "The thing that makes this link unique, which will be part of the link"
    t.datetime "expires_at", precision: nil, null: false, comment: "When the magic link stops working"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_magic_links_on_token", unique: true
  end

  create_table "my_seasons", force: :cascade do |t|
    t.bigint "human_id", null: false, comment: "Which human saved this season"
    t.bigint "season_id", null: false, comment: "Which season did this human save"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "watched_episode_numbers", default: [], null: false, comment: "Which episodes has this person watched?", array: true
    t.index ["human_id", "season_id"], name: "index_my_seasons_on_human_id_and_season_id", unique: true
    t.index ["human_id"], name: "index_my_seasons_on_human_id"
    t.index ["season_id"], name: "index_my_seasons_on_season_id"
  end

  create_table "my_shows", force: :cascade do |t|
    t.bigint "human_id", null: false, comment: "Which human has saved this show"
    t.bigint "show_id", null: false, comment: "Which show this human has saved"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "note_to_self", comment: "An optional blob of Markdown-formatted text that the human can write to remind themselves why they've added the show, or however they want to use it"
    t.enum "status", default: "might_watch", null: false, enum_type: "my_show_status"
    t.index ["human_id", "show_id"], name: "index_my_shows_on_human_id_and_show_id", unique: true
    t.index ["human_id"], name: "index_my_shows_on_human_id"
    t.index ["show_id"], name: "index_my_shows_on_show_id"
  end

  create_table "season_reviews", force: :cascade do |t|
    t.bigint "author_id", null: false, comment: "Who wrote this review"
    t.bigint "season_id", null: false, comment: "Which season are they reviewing"
    t.text "body", null: false, comment: "The body of the review"
    t.integer "rating", comment: "The rating between 0 and 10 (optional)"
    t.integer "viewing", null: false, comment: "Is this the person's first, second, third etc viewing of the season?"
    t.enum "visibility", default: "anybody", null: false, comment: "Who can see this review", enum_type: "visibility"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id", "season_id", "viewing"], name: "index_season_reviews_on_author_id_and_season_id_and_viewing", unique: true
    t.index ["author_id"], name: "index_season_reviews_on_author_id"
    t.index ["season_id"], name: "index_season_reviews_on_season_id"
  end

  create_table "seasons", force: :cascade do |t|
    t.bigint "show_id", null: false, comment: "Which show this season is part of"
    t.integer "tmdb_id", null: false
    t.string "name", null: false
    t.integer "season_number", null: false
    t.integer "episode_count", null: false
    t.string "slug", null: false, comment: "A URL-friendly slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tmdb_poster_path"
    t.index ["show_id", "slug"], name: "index_seasons_on_show_id_and_slug", unique: true
    t.index ["show_id"], name: "index_seasons_on_show_id"
    t.index ["tmdb_id"], name: "index_seasons_on_tmdb_id", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "shows", force: :cascade do |t|
    t.string "title", null: false, comment: "The show's official title"
    t.string "slug", null: false, comment: "The show's title, in slug form, to go in a URL"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tmdb_tv_id", null: false
    t.string "tmdb_poster_path"
    t.datetime "tmdb_next_refresh_at", precision: nil
    t.date "first_air_date", comment: "What date did this show first air?"
    t.datetime "tmdb_last_refreshed_at", precision: nil, comment: "When did we last refresh this show's info from TMDB?"
    t.index ["slug"], name: "index_shows_on_slug", unique: true
    t.index ["tmdb_tv_id"], name: "index_shows_on_tmdb_tv_id", unique: true
  end

  create_table "tmdb_api_configurations", force: :cascade do |t|
    t.string "secure_base_url", null: false
    t.datetime "fetched_at", precision: nil, null: false
    t.string "poster_sizes", null: false, array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "still_sizes", null: false, comment: "Available sizes for episode stills", array: true
    t.index ["poster_sizes"], name: "index_tmdb_api_configurations_on_poster_sizes", using: :gin
  end

  add_foreign_key "browser_sessions", "humans", on_delete: :cascade
  add_foreign_key "follows", "humans", column: "followee_id", on_delete: :cascade
  add_foreign_key "follows", "humans", column: "follower_id", on_delete: :cascade
  add_foreign_key "my_seasons", "humans", on_delete: :cascade
  add_foreign_key "my_seasons", "seasons", on_delete: :cascade
  add_foreign_key "my_shows", "humans", on_delete: :cascade
  add_foreign_key "my_shows", "shows", on_delete: :cascade
  add_foreign_key "season_reviews", "humans", column: "author_id", on_delete: :cascade
  add_foreign_key "season_reviews", "seasons", on_delete: :cascade
end
