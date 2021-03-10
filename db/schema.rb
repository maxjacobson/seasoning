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

ActiveRecord::Schema.define(version: 2021_03_10_073728) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "browser_sessions", force: :cascade do |t|
    t.string "token", null: false, comment: "The token that will be kept in localstorage and included with API requests"
    t.bigint "human_id", null: false
    t.datetime "last_seen_at", null: false, comment: "When the human last visited during this session"
    t.datetime "expires_at", null: false, comment: "The time at which we should stop honoring the token and force them to log in again"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["human_id"], name: "index_browser_sessions_on_human_id"
  end

  create_table "humans", force: :cascade do |t|
    t.string "handle", null: false, comment: "The handle is the human's nickname, username, or whatever you want to call it"
    t.string "email", null: false, comment: "Their email. This is how they'll log in. No passwords. Just click a link in your email."
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "humans_email_unique", unique: true
    t.index ["handle"], name: "humans_handle_unique", unique: true
  end

  create_table "magic_links", force: :cascade do |t|
    t.string "email", null: false, comment: "The email address that the magic link is sent to. Following the link proves they are this human."
    t.string "token", null: false, comment: "The thing that makes this link unique, which will be part of the link"
    t.datetime "expires_at", null: false, comment: "When the magic link stops working"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["token"], name: "index_magic_links_on_token", unique: true
  end

  add_foreign_key "browser_sessions", "humans", on_delete: :cascade
end
