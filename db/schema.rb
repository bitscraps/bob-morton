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

ActiveRecord::Schema.define(version: 20180625185312) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "branches", force: :cascade do |t|
    t.string   "name"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "commits", force: :cascade do |t|
    t.string   "sha"
    t.integer  "merge_branch_rubocop_warnings"
    t.integer  "this_branch_rubocop_warnings"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.text     "rubocop_output"
    t.integer  "number"
    t.integer  "merge_branch_brakeman_warnings"
    t.integer  "this_branch_brakeman_warnings"
    t.text     "brakeman_output"
    t.integer  "branch_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.string   "email"
    t.string   "uid"
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string   "github_project_user"
    t.string   "github_project_name"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "projects_users", force: :cascade do |t|
    t.integer "project_id"
    t.integer "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "warnings", force: :cascade do |t|
    t.string   "source"
    t.text     "filename"
    t.integer  "line_number"
    t.text     "description"
    t.string   "log_level"
    t.integer  "commit_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end
end
