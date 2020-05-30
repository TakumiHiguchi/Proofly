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

ActiveRecord::Schema.define(version: 20200512182850) do

  create_table "article_index_results", force: :cascade do |t|
    t.integer "article_id", limit: 8
    t.boolean "result", default: false
    t.string "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "article_indices", force: :cascade do |t|
    t.integer "article_id", limit: 8, default: 0
    t.integer "applicant_id", limit: 8, default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "article_sales", force: :cascade do |t|
    t.integer "article_id", limit: 8
    t.integer "sales_type"
    t.integer "price"
    t.integer "afe"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "articles", force: :cascade do |t|
    t.integer "user_detail_id", limit: 8
    t.string "key"
    t.string "title"
    t.string "description"
    t.text "content"
    t.text "paidcontent"
    t.string "article_status"
    t.string "thum"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "index", default: false, null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.string "cate_key"
    t.integer "parent_id", limit: 8
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fixed_pages", force: :cascade do |t|
    t.string "fix_key"
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "post_category_relations", force: :cascade do |t|
    t.integer "article_id", limit: 8
    t.integer "category_id", limit: 8
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "post_tag_relations", force: :cascade do |t|
    t.string "article_id"
    t.string "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "purchased_works", force: :cascade do |t|
    t.integer "article_id", limit: 8
    t.integer "user_id", limit: 8
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pv_articles", force: :cascade do |t|
    t.integer "article_id", limit: 8, default: 0
    t.integer "count", limit: 8, default: 0
    t.string "last_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "user_detail_id"
    t.integer "follow_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["follow_id"], name: "index_relationships_on_follow_id"
    t.index ["user_detail_id", "follow_id"], name: "index_relationships_on_user_detail_id_and_follow_id", unique: true
    t.index ["user_detail_id"], name: "index_relationships_on_user_detail_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.string "tag_key"
    t.integer "tag_type"
    t.integer "created_user_id", limit: 8
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_details", force: :cascade do |t|
    t.string "user_key"
    t.string "name"
    t.string "bio"
    t.string "location"
    t.string "website"
    t.string "thum1"
    t.string "thum2"
    t.integer "user_id", limit: 8
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_scores", force: :cascade do |t|
    t.integer "user_detail_id", limit: 8
    t.integer "score", limit: 8, default: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
