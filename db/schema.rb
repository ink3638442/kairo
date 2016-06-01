# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160519012457) do

  create_table "cards", force: :cascade do |t|
    t.string   "kind"
    t.string   "title"
    t.text     "content"
    t.string   "image"
    t.boolean  "pick_up",    default: false
    t.integer  "user_id"
    t.integer  "page_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "cards", ["page_id"], name: "index_cards_on_page_id"
  add_index "cards", ["user_id"], name: "index_cards_on_user_id"

  create_table "group_threads", force: :cascade do |t|
    t.string   "title"
    t.integer  "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "content"
  end

  add_index "group_threads", ["group_id"], name: "index_group_threads_on_group_id"

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pages", force: :cascade do |t|
    t.string   "title"
    t.text     "card_order"
    t.text     "content"
    t.date     "group_joined_at"
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "pages", ["group_id"], name: "index_pages_on_group_id"
  add_index "pages", ["user_id"], name: "index_pages_on_user_id"

  create_table "thread_contents", force: :cascade do |t|
    t.integer  "group_thread_id"
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "thread_contents", ["group_thread_id"], name: "index_thread_contents_on_group_thread_id"
  add_index "thread_contents", ["user_id"], name: "index_thread_contents_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "password_digest"
    t.string   "image"
    t.boolean  "admin"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
