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

ActiveRecord::Schema.define(version: 20151128165850) do

  create_table "accounts", force: :cascade do |t|
    t.integer  "account_type", limit: 4,                              default: 0
    t.string   "title",        limit: 255
    t.text     "description",  limit: 65535
    t.decimal  "value",                      precision: 15, scale: 2, default: 0.0
    t.integer  "user_id",      limit: 4
    t.datetime "created_at",                                                        null: false
    t.datetime "updated_at",                                                        null: false
  end

  add_index "accounts", ["user_id"], name: "index_accounts_on_user_id", using: :btree

  create_table "cards", force: :cascade do |t|
    t.integer  "brand",        limit: 4
    t.string   "title",        limit: 255
    t.decimal  "credit_limit",             precision: 15, scale: 2, default: 0.0
    t.integer  "billing_day",  limit: 4
    t.integer  "payment_day",  limit: 4
    t.integer  "account_id",   limit: 4
    t.integer  "user_id",      limit: 4
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
  end

  add_index "cards", ["account_id"], name: "index_cards_on_account_id", using: :btree
  add_index "cards", ["user_id"], name: "index_cards_on_user_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.text     "description", limit: 65535
    t.string   "color",       limit: 255
    t.integer  "user_id",     limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "categories", ["user_id"], name: "index_categories_on_user_id", using: :btree

  create_table "goals", force: :cascade do |t|
    t.decimal  "value",                 precision: 15, scale: 2, default: 0.0
    t.integer  "category_id", limit: 4
    t.datetime "created_at",                                                   null: false
    t.datetime "updated_at",                                                   null: false
  end

  add_index "goals", ["category_id"], name: "index_goals_on_category_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.text     "description", limit: 65535
    t.integer  "user_id",     limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "groups", ["user_id"], name: "index_groups_on_user_id", using: :btree

  create_table "installments", force: :cascade do |t|
    t.string   "title",                  limit: 255
    t.text     "description",            limit: 65535
    t.decimal  "value",                                precision: 15, scale: 2, default: 0.0
    t.datetime "date"
    t.boolean  "paid",                                                          default: false
    t.integer  "launch_type",            limit: 4
    t.integer  "number_installment",     limit: 4
    t.integer  "installmentable_id",     limit: 4
    t.string   "installmentable_type",   limit: 255
    t.integer  "category_id",            limit: 4
    t.integer  "user_id",                limit: 4
    t.integer  "launch_id",              limit: 4
    t.integer  "group_id",               limit: 4
    t.integer  "parent_launch_group_id", limit: 4
    t.datetime "created_at",                                                                    null: false
    t.datetime "updated_at",                                                                    null: false
  end

  add_index "installments", ["category_id"], name: "index_installments_on_category_id", using: :btree
  add_index "installments", ["group_id"], name: "index_installments_on_group_id", using: :btree
  add_index "installments", ["launch_id"], name: "index_installments_on_launch_id", using: :btree
  add_index "installments", ["parent_launch_group_id"], name: "index_installments_on_parent_launch_group_id", using: :btree
  add_index "installments", ["user_id"], name: "index_installments_on_user_id", using: :btree

  create_table "launches", force: :cascade do |t|
    t.string   "title",                 limit: 255
    t.text     "description",           limit: 65535
    t.decimal  "value",                               precision: 15, scale: 2, default: 0.0
    t.datetime "date"
    t.boolean  "paid",                                                         default: false
    t.integer  "launchable_id",         limit: 4
    t.string   "launchable_type",       limit: 255
    t.integer  "recurrence_type",       limit: 4,                              default: 0
    t.integer  "amount_installment",    limit: 4,                              default: 1
    t.integer  "recurrence",            limit: 4,                              default: 4
    t.integer  "launch_type",           limit: 4
    t.datetime "last_installment_date"
    t.boolean  "enabled",                                                      default: true
    t.integer  "category_id",           limit: 4
    t.integer  "user_id",               limit: 4
    t.integer  "group_id",              limit: 4
    t.datetime "created_at",                                                                   null: false
    t.datetime "updated_at",                                                                   null: false
  end

  add_index "launches", ["category_id"], name: "index_launches_on_category_id", using: :btree
  add_index "launches", ["group_id"], name: "index_launches_on_group_id", using: :btree
  add_index "launches", ["launchable_type", "launchable_id"], name: "index_launches_on_launchable_type_and_launchable_id", using: :btree
  add_index "launches", ["user_id"], name: "index_launches_on_user_id", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.string   "title",       limit: 255
    t.text     "description", limit: 65535
    t.boolean  "check",                     default: false
    t.string   "icon",        limit: 255
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "user_groups", force: :cascade do |t|
    t.boolean  "enabled",                default: false
    t.integer  "role",       limit: 4,   default: 1
    t.integer  "group_id",   limit: 4
    t.integer  "user_id",    limit: 4
    t.string   "email",      limit: 255, default: "",    null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "user_groups", ["group_id"], name: "index_user_groups_on_group_id", using: :btree
  add_index "user_groups", ["user_id"], name: "index_user_groups_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255,   default: "",      null: false
    t.string   "encrypted_password",     limit: 255,   default: "",      null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,     default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "provider",               limit: 255,   default: "email", null: false
    t.string   "uid",                    limit: 255,   default: "",      null: false
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.text     "tokens",                 limit: 65535
    t.string   "name",                   limit: 255
    t.string   "nickname",               limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree

  add_foreign_key "accounts", "users"
  add_foreign_key "cards", "accounts"
  add_foreign_key "cards", "users"
  add_foreign_key "categories", "users"
  add_foreign_key "goals", "categories"
  add_foreign_key "groups", "users"
  add_foreign_key "installments", "categories"
  add_foreign_key "installments", "groups"
  add_foreign_key "installments", "launches"
  add_foreign_key "installments", "users"
  add_foreign_key "launches", "categories"
  add_foreign_key "launches", "groups"
  add_foreign_key "launches", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "user_groups", "groups"
  add_foreign_key "user_groups", "users"
end
