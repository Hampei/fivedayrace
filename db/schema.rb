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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120505155135) do

  create_table "activity_days", :force => true do |t|
    t.integer  "user_id"
    t.date     "date"
    t.integer  "steps"
    t.integer  "stairs"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "apn_apps", :force => true do |t|
    t.text     "apn_dev_cert"
    t.text     "apn_prod_cert"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "apn_device_groupings", :force => true do |t|
    t.integer "group_id"
    t.integer "device_id"
  end

  add_index "apn_device_groupings", ["device_id"], :name => "index_apn_device_groupings_on_device_id"
  add_index "apn_device_groupings", ["group_id", "device_id"], :name => "index_apn_device_groupings_on_group_id_and_device_id"
  add_index "apn_device_groupings", ["group_id"], :name => "index_apn_device_groupings_on_group_id"

  create_table "apn_devices", :force => true do |t|
    t.string   "token",              :null => false
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.datetime "last_registered_at"
    t.integer  "app_id"
  end

  add_index "apn_devices", ["token"], :name => "index_apn_devices_on_token"

  create_table "apn_group_notifications", :force => true do |t|
    t.integer  "group_id",          :null => false
    t.string   "device_language"
    t.string   "sound"
    t.string   "alert"
    t.integer  "badge"
    t.text     "custom_properties"
    t.datetime "sent_at"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "apn_group_notifications", ["group_id"], :name => "index_apn_group_notifications_on_group_id"

  create_table "apn_groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "app_id"
  end

  create_table "apn_notifications", :force => true do |t|
    t.integer  "device_id",                        :null => false
    t.integer  "errors_nb",         :default => 0
    t.string   "device_language"
    t.string   "sound"
    t.string   "alert"
    t.integer  "badge"
    t.datetime "sent_at"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.text     "custom_properties"
  end

  add_index "apn_notifications", ["device_id"], :name => "index_apn_notifications_on_device_id"

  create_table "apn_pull_notifications", :force => true do |t|
    t.integer  "app_id"
    t.string   "title"
    t.string   "content"
    t.string   "link"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.boolean  "launch_notification"
  end

  create_table "following_users", :force => true do |t|
    t.integer "user_id",      :null => false
    t.integer "following_id", :null => false
  end

  add_index "following_users", ["following_id"], :name => "index_following_users_on_following_id"
  add_index "following_users", ["user_id"], :name => "index_following_users_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "fitbit_token"
    t.string   "fitbit_secret"
    t.string   "fitbit_uid"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.string   "avatar",                      :default => "", :null => false
    t.string   "app_token",     :limit => 32, :default => "", :null => false
  end

end
