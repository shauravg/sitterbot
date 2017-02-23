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

ActiveRecord::Schema.define(version: 20161122051905) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "event_requests", force: :cascade do |t|
    t.integer  "event_id",                   null: false
    t.integer  "sitter_id",                  null: false
    t.boolean  "texted",     default: false
    t.boolean  "emailed",    default: false
    t.integer  "state",      default: 0
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "event_requests", ["event_id"], name: "index_event_requests_on_event_id", using: :btree
  add_index "event_requests", ["sitter_id"], name: "index_event_requests_on_sitter_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.boolean  "food_included", default: false
    t.datetime "starts_at",                     null: false
    t.datetime "ends_at",                       null: false
    t.string   "key",                           null: false
    t.integer  "sitter_id"
    t.integer  "parent_id",                     null: false
    t.integer  "flat_rate"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "name"
    t.boolean  "reminded",      default: false
    t.boolean  "started",       default: false
  end

  add_index "events", ["parent_id"], name: "index_events_on_parent_id", using: :btree
  add_index "events", ["sitter_id"], name: "index_events_on_sitter_id", using: :btree

  create_table "kids", force: :cascade do |t|
    t.integer  "parent_id",    null: false
    t.string   "nickname",     null: false
    t.date     "birthdate"
    t.text     "instructions"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "kids", ["parent_id"], name: "index_kids_on_parent_id", using: :btree

  create_table "plans", force: :cascade do |t|
    t.string   "name",          null: false
    t.string   "stripe_id",     null: false
    t.integer  "price"
    t.string   "interval"
    t.text     "features"
    t.boolean  "highlight"
    t.integer  "display_order"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "sitters", force: :cascade do |t|
    t.integer  "parent_id",                    null: false
    t.boolean  "paid",          default: true
    t.integer  "hourly_rate",   default: 10
    t.string   "phone"
    t.string   "email"
    t.string   "name",                         null: false
    t.boolean  "can_drive",     default: true
    t.integer  "per_extra_kid"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "ord",           default: 0
  end

  add_index "sitters", ["parent_id"], name: "index_sitters_on_parent_id", using: :btree

  create_table "ssl_verifications", force: :cascade do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string   "stripe_id"
    t.integer  "plan_id",           null: false
    t.string   "last_four"
    t.integer  "coupon_id"
    t.string   "card_type"
    t.integer  "current_price"
    t.integer  "parent_id"
    t.datetime "paid_thru"
    t.string   "credit_card_token"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "subscriptions", ["plan_id"], name: "index_subscriptions_on_plan_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",           null: false
    t.string   "password_digest"
    t.string   "session_token",   null: false
    t.string   "reset_token"
    t.string   "selected_plan"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "name"
    t.string   "phone"
    t.string   "time_zone"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree

end
