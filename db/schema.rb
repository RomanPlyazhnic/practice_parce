# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_09_15_175630) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "animes", force: :cascade do |t|
    t.string "name"
    t.string "kind"
    t.string "studio"
    t.string "year"
    t.integer "rank"
    t.string "image_href"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_animes_on_name"
    t.index ["rank"], name: "index_animes_on_rank"
    t.index ["studio"], name: "index_animes_on_studio"
    t.index ["year"], name: "index_animes_on_year"
  end

  create_table "genres", force: :cascade do |t|
    t.bigint "anime_id"
    t.string "genre"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["anime_id"], name: "index_genres_on_anime_id"
    t.index ["genre"], name: "index_genres_on_genre"
  end

  create_table "testdb", id: false, force: :cascade do |t|
    t.string "name", limit: 50
  end

  create_table "tests", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "genres", "animes"
end
