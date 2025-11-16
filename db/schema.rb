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

ActiveRecord::Schema[8.2].define(version: 2025_11_16_215544) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "my_show_status", ["might_watch", "currently_watching", "stopped_watching", "waiting_for_more", "finished", "next_up"]
  create_enum "visibility", ["anybody", "myself"]

  create_table "episodes", force: :cascade do |t|
    t.date "air_date", comment: "What date did this episode first air?"
    t.datetime "created_at", null: false
    t.integer "episode_number", null: false, comment: "The position of the episode in the season"
    t.string "name", null: false, comment: "The episode's official name"
    t.bigint "season_id", null: false, comment: "Which season this episode is part of"
    t.string "still_path", comment: "TMDB path to a photo related to the episode"
    t.integer "tmdb_id", null: false, comment: "The episode's id on TMDB"
    t.datetime "updated_at", null: false
    t.index ["season_id", "episode_number"], name: "index_episodes_on_season_id_and_episode_number", unique: true
    t.index ["season_id"], name: "index_episodes_on_season_id"
    t.index ["tmdb_id"], name: "index_episodes_on_tmdb_id", unique: true
  end

  create_table "follows", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "followee_id", null: false, comment: "Who is the person being followed"
    t.bigint "follower_id", null: false, comment: "Who is the person doing the following"
    t.datetime "updated_at", null: false
    t.index ["followee_id"], name: "index_follows_on_followee_id"
    t.index ["follower_id", "followee_id"], name: "index_follows_on_follower_id_and_followee_id", unique: true
    t.index ["follower_id"], name: "index_follows_on_follower_id"
  end

  create_table "humans", force: :cascade do |t|
    t.boolean "admin", default: false, null: false, comment: "Gives humans some extra abilities to see things like the admin stats page"
    t.datetime "created_at", null: false
    t.integer "currently_watching_limit", comment: "How many shows, at most, does this human want to watch at once?"
    t.enum "default_review_visibility", default: "anybody", null: false, comment: "Lets people specify who they generally want to share their reviews with, to save them some clicking", enum_type: "visibility"
    t.string "email", null: false, comment: "Their email. This is how they'll log in. No passwords. Just click a link in your email."
    t.string "handle", null: false, comment: "The handle is the human's nickname, username, or whatever you want to call it"
    t.boolean "share_currently_watching", default: true, null: false, comment: "Whether or not to publicly display your currently watching list on the profile page"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "humans_email_unique", unique: true
    t.index ["handle"], name: "humans_handle_unique", unique: true
  end

  create_table "magic_links", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false, comment: "The email address that the magic link is sent to. Following the link proves they are this human."
    t.datetime "expires_at", precision: nil, null: false, comment: "When the magic link stops working"
    t.string "token", null: false, comment: "The thing that makes this link unique, which will be part of the link"
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_magic_links_on_token", unique: true
  end

  create_table "my_seasons", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "human_id", null: false, comment: "Which human saved this season"
    t.bigint "season_id", null: false, comment: "Which season did this human save"
    t.boolean "skipped", default: false, null: false
    t.datetime "updated_at", null: false
    t.integer "watched_episode_numbers", default: [], null: false, comment: "Which episodes has this person watched?", array: true
    t.index ["human_id", "season_id"], name: "index_my_seasons_on_human_id_and_season_id", unique: true
    t.index ["human_id"], name: "index_my_seasons_on_human_id"
    t.index ["season_id"], name: "index_my_seasons_on_season_id"
  end

  create_table "my_shows", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "human_id", null: false, comment: "Which human has saved this show"
    t.text "note_to_self", comment: "An optional blob of Markdown-formatted text that the human can write to remind themselves why they've added the show, or however they want to use it"
    t.bigint "show_id", null: false, comment: "Which show this human has saved"
    t.enum "status", default: "might_watch", null: false, enum_type: "my_show_status"
    t.datetime "updated_at", null: false
    t.index ["human_id", "show_id"], name: "index_my_shows_on_human_id_and_show_id", unique: true
    t.index ["human_id"], name: "index_my_shows_on_human_id"
    t.index ["show_id"], name: "index_my_shows_on_show_id"
  end

  create_table "returning_show_notifications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "human_id", null: false, comment: "Which human should receive this notification"
    t.bigint "show_id", null: false, comment: "Which show is returning"
    t.datetime "updated_at", null: false
    t.index ["human_id", "show_id"], name: "index_returning_show_notifications_on_human_and_show", unique: true
    t.index ["human_id"], name: "index_returning_show_notifications_on_human_id"
    t.index ["show_id"], name: "index_returning_show_notifications_on_show_id"
  end

  create_table "season_reviews", force: :cascade do |t|
    t.bigint "author_id", null: false, comment: "Who wrote this review"
    t.text "body", null: false, comment: "The body of the review"
    t.datetime "created_at", null: false
    t.integer "rating", comment: "The rating between 0 and 10 (optional)"
    t.bigint "season_id", null: false, comment: "Which season are they reviewing"
    t.datetime "updated_at", null: false
    t.integer "viewing", null: false, comment: "Is this the person's first, second, third etc viewing of the season?"
    t.enum "visibility", default: "anybody", null: false, comment: "Who can see this review", enum_type: "visibility"
    t.index ["author_id", "season_id", "viewing"], name: "index_season_reviews_on_author_id_and_season_id_and_viewing", unique: true
    t.index ["author_id"], name: "index_season_reviews_on_author_id"
    t.index ["season_id"], name: "index_season_reviews_on_season_id"
  end

  create_table "seasons", force: :cascade do |t|
    t.date "air_date"
    t.datetime "created_at", null: false
    t.integer "episode_count", null: false
    t.string "name", null: false
    t.integer "season_number", null: false
    t.bigint "show_id", null: false, comment: "Which show this season is part of"
    t.string "slug", null: false, comment: "A URL-friendly slug"
    t.integer "tmdb_id", null: false
    t.string "tmdb_poster_path"
    t.datetime "updated_at", null: false
    t.index ["show_id", "slug"], name: "index_seasons_on_show_id_and_slug", unique: true
    t.index ["show_id"], name: "index_seasons_on_show_id"
    t.index ["tmdb_id"], name: "index_seasons_on_tmdb_id", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "data"
    t.string "session_id", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "shows", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "first_air_date", comment: "What date did this show first air?"
    t.string "slug", null: false, comment: "The show's title, in slug form, to go in a URL"
    t.string "sort_by_title", null: false, comment: "The show's title normalized for sorting (strips leading articles like 'The', 'A', 'An')"
    t.string "title", null: false, comment: "The show's official title"
    t.datetime "tmdb_last_refreshed_at", precision: nil, comment: "When did we last refresh this show's info from TMDB?"
    t.datetime "tmdb_next_refresh_at", precision: nil
    t.string "tmdb_poster_path"
    t.integer "tmdb_tv_id", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_shows_on_slug", unique: true
    t.index ["tmdb_tv_id"], name: "index_shows_on_tmdb_tv_id", unique: true
  end

  create_table "tmdb_api_configurations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "fetched_at", precision: nil, null: false
    t.string "poster_sizes", null: false, array: true
    t.string "secure_base_url", null: false
    t.string "still_sizes", null: false, comment: "Available sizes for episode stills", array: true
    t.datetime "updated_at", null: false
    t.index ["poster_sizes"], name: "index_tmdb_api_configurations_on_poster_sizes", using: :gin
  end

  add_foreign_key "follows", "humans", column: "followee_id", on_delete: :cascade
  add_foreign_key "follows", "humans", column: "follower_id", on_delete: :cascade
  add_foreign_key "my_seasons", "humans", on_delete: :cascade
  add_foreign_key "my_seasons", "seasons", on_delete: :cascade
  add_foreign_key "my_shows", "humans", on_delete: :cascade
  add_foreign_key "my_shows", "shows", on_delete: :cascade
  add_foreign_key "returning_show_notifications", "humans", on_delete: :cascade
  add_foreign_key "returning_show_notifications", "shows", on_delete: :cascade
  add_foreign_key "season_reviews", "humans", column: "author_id", on_delete: :cascade
  add_foreign_key "season_reviews", "seasons", on_delete: :cascade
end
