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

ActiveRecord::Schema.define(version: 20140924201343) do

  create_table "bar_geoflipper", force: true do |t|
    t.integer "bar_id"
    t.string  "name"
    t.string  "url"
    t.float   "latitude",    limit: 24
    t.float   "longitude",   limit: 24
    t.string  "last_update"
  end

  add_index "bar_geoflipper", ["url"], name: "index_bar_geoflipper_on_url", unique: true, using: :btree

  create_table "bar_google", force: true do |t|
    t.integer  "bar_id"
    t.string   "name"
    t.string   "address"
    t.float    "rating",     limit: 24
    t.float    "latitude",   limit: 24
    t.float    "longitude",  limit: 24
    t.string   "types"
    t.string   "place_id"
    t.string   "old_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bar_google", ["bar_id"], name: "bar_google_ibfk_1", using: :btree

  create_table "bar_mistergoodbeer", force: true do |t|
    t.integer  "bar_id"
    t.string   "url"
    t.string   "name"
    t.string   "address"
    t.float    "price",      limit: 24
    t.float    "hh_price",   limit: 24
    t.string   "hh_open"
    t.string   "hh_close"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bar_mistergoodbeer", ["bar_id"], name: "bar_mistergoodbeer_ibfk_1", using: :btree

  create_table "bars", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.float    "latitude",   limit: 24
    t.float    "longitude",  limit: 24
    t.float    "price",      limit: 24
    t.string   "open"
    t.string   "close"
    t.float    "hh_price",   limit: 24
    t.string   "hh_open"
    t.string   "hh_close"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pinball_geoflipper", force: true do |t|
    t.integer  "pinball_id"
    t.integer  "bar_id"
    t.string   "name"
    t.string   "manufacturer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pinball_geoflipper", ["bar_id"], name: "pinball_geoflipper_ibfk_2", using: :btree
  add_index "pinball_geoflipper", ["pinball_id"], name: "pinball_geoflipper_ibfk_1", using: :btree

  create_table "pinball_ipdb", force: true do |t|
    t.integer "ipdb_id"
    t.integer "pinball_id"
    t.string  "name"
    t.string  "manufacturer"
    t.integer "year"
    t.float   "rating",           limit: 24
    t.float   "rating_art",       limit: 24
    t.float   "rating_audio",     limit: 24
    t.float   "rating_playfield", limit: 24
    t.float   "rating_gameplay",  limit: 24
    t.integer "ratings"
  end

  add_index "pinball_ipdb", ["ipdb_id"], name: "index_pinball_ipdb_on_ipdb_id", unique: true, using: :btree
  add_index "pinball_ipdb", ["pinball_id"], name: "pinball_ipdb_ibfk_1", using: :btree

  create_table "pinballs", force: true do |t|
    t.string  "name"
    t.string  "manufacturer"
    t.integer "year"
  end

end
