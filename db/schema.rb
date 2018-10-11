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

ActiveRecord::Schema.define(version: 20181010154342) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.index ["organization_id"], name: "index_statistics_on_organization_id"
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
  end

  add_foreign_key "repositories", "organizations"
  add_foreign_key "statistics", "organizations"
end
