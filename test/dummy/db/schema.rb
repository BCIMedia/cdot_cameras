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

ActiveRecord::Schema.define(version: 20180329221412) do

  create_table "cdot_camera_camera_views", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "description",     limit: 255
    t.string   "source",          limit: 255
    t.integer  "cdot_view_id",    limit: 4
    t.integer  "direction",       limit: 4
    t.string   "image_location",  limit: 255
    t.integer  "display_order",   limit: 4
    t.string   "road_name",       limit: 255
    t.integer  "road_id",         limit: 4
    t.datetime "last_updated_at"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "cdot_camera_cameras", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "description",     limit: 255
    t.float    "latitude",        limit: 24
    t.float    "longitude",       limit: 24
    t.string   "source",          limit: 255
    t.string   "icon",            limit: 255
    t.integer  "status",          limit: 4
    t.boolean  "weather_station"
    t.integer  "cdot_camera_id",  limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

end
