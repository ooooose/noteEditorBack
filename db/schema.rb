# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_09_30_134410) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "badges", force: :cascade do |t|
    t.bigint "pictures_id", null: false
    t.bigint "contests_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contests_id"], name: "index_badges_on_contests_id"
    t.index ["pictures_id"], name: "index_badges_on_pictures_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "picture_id", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_comments_on_created_at"
    t.index ["picture_id"], name: "index_comments_on_picture_id"
    t.index ["user_id", "picture_id"], name: "index_comments_on_user_id_and_picture_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "contests", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.datetime "start_date", null: false
    t.datetime "end_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["created_at"], name: "index_contests_on_created_at"
    t.index ["deleted_at"], name: "index_contests_on_deleted_at"
    t.index ["end_date"], name: "index_contests_on_end_date"
    t.index ["start_date"], name: "index_contests_on_start_date"
    t.index ["title"], name: "unique_contest_title", unique: true
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "picture_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["picture_id"], name: "index_likes_on_picture_id"
    t.index ["user_id", "picture_id"], name: "index_likes_on_user_id_and_picture_id", unique: true
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "pictures", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "theme_id", null: false
    t.string "uid", null: false
    t.text "image_url", null: false
    t.integer "frame_id", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["created_at"], name: "index_pictures_on_created_at"
    t.index ["deleted_at"], name: "index_pictures_on_deleted_at"
    t.index ["theme_id"], name: "index_pictures_on_theme_id"
    t.index ["uid"], name: "unique_picture_uid", unique: true
    t.index ["user_id"], name: "index_pictures_on_user_id"
  end

  create_table "themes", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_themes_on_deleted_at"
    t.index ["title"], name: "unique_theme_title", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name", limit: 40, null: false
    t.string "uid", null: false
    t.string "email", null: false
    t.string "image"
    t.integer "role", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "unique_user_emails", unique: true
    t.index ["uid"], name: "unique_user_uid", unique: true
  end

  add_foreign_key "badges", "contests", column: "contests_id"
  add_foreign_key "badges", "pictures", column: "pictures_id"
  add_foreign_key "comments", "pictures"
  add_foreign_key "comments", "users"
  add_foreign_key "likes", "pictures"
  add_foreign_key "likes", "users"
  add_foreign_key "pictures", "themes"
  add_foreign_key "pictures", "users"
end
