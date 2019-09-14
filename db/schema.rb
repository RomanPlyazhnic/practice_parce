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

ActiveRecord::Schema.define(version: 2019_09_14_143858) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "animes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "kind"
    t.string "studio"
    t.string "year"
    t.integer "rank"
    t.string "image_href"
    t.text "description"
    t.index ["name"], name: "index_animes_on_name"
    t.index ["rank"], name: "index_animes_on_rank"
    t.index ["studio"], name: "index_animes_on_studio"
    t.index ["year"], name: "index_animes_on_year"
  end

  create_table "genres", force: :cascade do |t|
    t.bigint "anime_id"
    t.boolean "senen", default: false, null: false
    t.boolean "seinen", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "Action"
    t.boolean "Adventure"
    t.boolean "BL"
    t.boolean "Comedy"
    t.boolean "Drama"
    t.boolean "Ecchi"
    t.boolean "Fantasy"
    t.boolean "GL"
    t.boolean "Harem"
    t.boolean "Horror"
    t.boolean "Josei"
    t.boolean "Magical_girl"
    t.boolean "Mecha"
    t.boolean "Mystery"
    t.boolean "Reverse_Harem"
    t.boolean "Romance"
    t.boolean "Sci_Fi"
    t.boolean "Seinen"
    t.boolean "Shoujo"
    t.boolean "Shoujo_ai"
    t.boolean "Shounen"
    t.boolean "Shounen_ai"
    t.boolean "Slice_of_Life"
    t.boolean "Sports"
    t.boolean "Yaoi"
    t.boolean "Yuri"
    t.index ["Action"], name: "index_genres_on_Action"
    t.index ["Adventure"], name: "index_genres_on_Adventure"
    t.index ["BL"], name: "index_genres_on_BL"
    t.index ["Comedy"], name: "index_genres_on_Comedy"
    t.index ["Drama"], name: "index_genres_on_Drama"
    t.index ["Ecchi"], name: "index_genres_on_Ecchi"
    t.index ["Fantasy"], name: "index_genres_on_Fantasy"
    t.index ["GL"], name: "index_genres_on_GL"
    t.index ["Harem"], name: "index_genres_on_Harem"
    t.index ["Horror"], name: "index_genres_on_Horror"
    t.index ["Josei"], name: "index_genres_on_Josei"
    t.index ["Magical_girl"], name: "index_genres_on_Magical_girl"
    t.index ["Mecha"], name: "index_genres_on_Mecha"
    t.index ["Mystery"], name: "index_genres_on_Mystery"
    t.index ["Reverse_Harem"], name: "index_genres_on_Reverse_Harem"
    t.index ["Romance"], name: "index_genres_on_Romance"
    t.index ["Sci_Fi"], name: "index_genres_on_Sci_Fi"
    t.index ["Seinen"], name: "index_genres_on_Seinen"
    t.index ["Shoujo"], name: "index_genres_on_Shoujo"
    t.index ["Shoujo_ai"], name: "index_genres_on_Shoujo_ai"
    t.index ["Shounen"], name: "index_genres_on_Shounen"
    t.index ["Shounen_ai"], name: "index_genres_on_Shounen_ai"
    t.index ["Slice_of_Life"], name: "index_genres_on_Slice_of_Life"
    t.index ["Sports"], name: "index_genres_on_Sports"
    t.index ["Yaoi"], name: "index_genres_on_Yaoi"
    t.index ["Yuri"], name: "index_genres_on_Yuri"
    t.index ["anime_id"], name: "index_genres_on_anime_id", unique: true
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
