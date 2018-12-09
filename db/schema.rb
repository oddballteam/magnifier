# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_12_08_163533) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accomplishments", force: :cascade do |t|
    t.bigint "week_in_review_id"
    t.bigint "statistic_id"
    t.string "type"
    t.string "action"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["statistic_id"], name: "index_accomplishments_on_statistic_id"
    t.index ["user_id"], name: "index_accomplishments_on_user_id"
    t.index ["week_in_review_id"], name: "index_accomplishments_on_week_in_review_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "week_in_review_id"
    t.text "body"
    t.string "type"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_comments_on_user_id"
    t.index ["week_in_review_id"], name: "index_comments_on_week_in_review_id"
  end

  create_table "github_users", force: :cascade do |t|
    t.integer "user_id"
    t.string "github_login"
    t.string "avatar_url"
    t.string "api_url"
    t.string "html_url"
    t.integer "github_id"
    t.boolean "oddball_employee", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "github_users_statistics", id: false, force: :cascade do |t|
    t.bigint "github_user_id"
    t.bigint "statistic_id"
    t.index ["github_user_id"], name: "index_github_users_statistics_on_github_user_id"
    t.index ["statistic_id"], name: "index_github_users_statistics_on_statistic_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "repositories", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.bigint "organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_repositories_on_organization_id"
  end

  create_table "statistics", force: :cascade do |t|
    t.string "source_id"
    t.string "source_type"
    t.string "source"
    t.string "state"
    t.integer "repository_id"
    t.bigint "organization_id"
    t.string "url"
    t.string "title"
    t.string "source_created_at"
    t.string "source_updated_at"
    t.string "source_closed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "source_created_by"
    t.integer "assignees", default: [], array: true
    t.index ["assignees"], name: "index_statistics_on_assignees", using: :gin
    t.index ["organization_id"], name: "index_statistics_on_organization_id"
    t.index ["source_created_by"], name: "index_statistics_on_source_created_by"
    t.index ["source_id"], name: "index_statistics_on_source_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "encrypted_personal_access_token"
    t.string "encrypted_personal_access_token_iv"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "github_username"
    t.integer "organization_id"
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.string "oauth_token"
    t.datetime "oauth_expires_at"
    t.index ["organization_id"], name: "index_users_on_organization_id"
  end

  create_table "week_in_reviews", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_week_in_reviews_on_user_id"
  end

  add_foreign_key "accomplishments", "users"
  add_foreign_key "comments", "users"
  add_foreign_key "comments", "week_in_reviews"
  add_foreign_key "repositories", "organizations"
  add_foreign_key "statistics", "organizations"
  add_foreign_key "week_in_reviews", "users"
end
