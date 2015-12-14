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

ActiveRecord::Schema.define(version: 20151213093530) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "buildings", force: :cascade do |t|
    t.integer  "collect_minute"
    t.datetime "last_collect"
    t.integer  "amount"
    t.string   "resource_type"
    t.integer  "city_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "buildings", ["city_id"], name: "index_buildings_on_city_id", using: :btree

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.boolean  "locked"
    t.integer  "stone",               default: 0
    t.integer  "wood",                default: 0
    t.integer  "population"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.integer  "win",                 default: 0
    t.integer  "lose",                default: 0
    t.string   "city_hash"
    t.integer  "max_building_amount", default: 20
    t.integer  "max_army_amount",     default: 20
    t.integer  "city_type"
    t.datetime "last_fight_date",     default: '2015-12-13 09:37:24'
  end

  add_index "cities", ["city_hash"], name: "index_cities_on_city_hash", using: :btree

  create_table "units", force: :cascade do |t|
    t.string   "name"
    t.integer  "attack"
    t.integer  "defence"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "city_id"
    t.integer  "unit_type"
  end

  add_index "units", ["city_id"], name: "index_units_on_city_id", using: :btree

end
