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

ActiveRecord::Schema.define(version: 2019_09_06_090950) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "auditoria", force: :cascade do |t|
    t.string "title"
    t.integer "capacity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "movies", force: :cascade do |t|
    t.string "title"
    t.string "rating"
    t.string "genre"
    t.integer "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "show_times", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.decimal "price"
    t.integer "tickets_available"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "movie_id"
    t.bigint "auditorium_id"
    t.index ["auditorium_id"], name: "index_show_times_on_auditorium_id"
    t.index ["movie_id"], name: "index_show_times_on_movie_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "show_time_id"
    t.integer "seat"
    t.index ["seat", "show_time_id"], name: "index_tickets_on_seat_and_show_time_id", unique: true
    t.index ["show_time_id"], name: "index_tickets_on_show_time_id"
  end

  add_foreign_key "show_times", "auditoria"
  add_foreign_key "show_times", "movies"
  add_foreign_key "tickets", "show_times"
end
