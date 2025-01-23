# frozen_string_literal: true

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

ActiveRecord::Schema.define(version: 20_241_216_185_842) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'acls', force: :cascade do |t|
    t.json 'sms', null: false
    t.json 'voice', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'api_keys', force: :cascade do |t|
    t.string 'value', null: false
    t.boolean 'is_active', default: true, null: false
    t.bigint 'user_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['user_id'], name: 'index_api_keys_on_user_id'
    t.index ['value'], name: 'index_api_keys_on_value', unique: true
  end

  create_table 'dids', force: :cascade do |t|
    t.string 'number', null: false
    t.bigint 'user_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['number'], name: 'index_dids_on_number', unique: true
    t.index ['user_id'], name: 'index_dids_on_user_id'
  end

  create_table 'restricted_ips', force: :cascade do |t|
    t.string 'value', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['value'], name: 'index_restricted_ips_on_value', unique: true
  end

  create_table 'settings', force: :cascade do |t|
    t.integer 'sms_per_sec', null: false
    t.integer 'voice_per_sec', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'users', force: :cascade do |t|
    t.bigint 'acl_id'
    t.bigint 'setting_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['acl_id'], name: 'index_users_on_acl_id'
    t.index ['setting_id'], name: 'index_users_on_setting_id'
  end

  add_foreign_key 'api_keys', 'users'
  add_foreign_key 'dids', 'users'
  add_foreign_key 'users', 'acls'
  add_foreign_key 'users', 'settings'
end
