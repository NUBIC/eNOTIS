# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090902092032) do

  create_table "activities", :force => true do |t|
    t.string   "controller"
    t.string   "action"
    t.text     "params"
    t.string   "whodiddit"
    t.datetime "created_at"
  end

  create_table "activity_items", :force => true do |t|
    t.integer "activity_id"
    t.string  "key"
    t.text    "value"
  end

  create_table "coordinators", :force => true do |t|
    t.integer  "study_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coordinators", ["study_id", "user_id"], :name => "coordinators_attr_idx", :unique => true

  create_table "dictionary_terms", :force => true do |t|
    t.string   "term"
    t.string   "code"
    t.string   "category"
    t.string   "source"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dictionary_terms", ["code", "category"], :name => "dictionary_attr_idx", :unique => true

  create_table "involvement_events", :force => true do |t|
    t.integer  "involvement_id"
    t.integer  "event_type_id"
    t.date     "occurred_on"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "involvement_events", ["event_type_id"], :name => "inv_events_type_idx"
  add_index "involvement_events", ["involvement_id", "event_type_id", "occurred_on"], :name => "inv_events_attr_idx", :unique => true
  add_index "involvement_events", ["occurred_on"], :name => "inv_events_occurred_idx"

  create_table "involvements", :force => true do |t|
    t.integer  "subject_id"
    t.integer  "study_id"
    t.integer  "ethnicity_type_id"
    t.integer  "gender_type_id"
    t.string   "case_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "involvements", ["subject_id", "study_id", "ethnicity_type_id", "gender_type_id"], :name => "involvements_attr_idx", :unique => true

  create_table "races", :force => true do |t|
    t.integer  "involvement_id"
    t.integer  "race_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "races", ["involvement_id", "race_type_id"], :name => "races_attr_idx", :unique => true

  create_table "resource_statuses", :force => true do |t|
    t.string   "name",       :null => false
    t.boolean  "status"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "studies", :force => true do |t|
    t.string   "irb_number"
    t.string   "name"
    t.text     "title"
    t.string   "phase"
    t.string   "research_type"
    t.text     "description"
    t.string   "status"
    t.string   "pi_netid"
    t.string   "pi_first_name"
    t.string   "pi_last_name"
    t.string   "pi_email"
    t.string   "sc_netid"
    t.string   "sc_first_name"
    t.string   "sc_last_name"
    t.string   "sc_email"
    t.datetime "synced_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "studies", ["irb_number"], :name => "studies_irb_number_idx", :unique => true

  create_table "study_uploads", :force => true do |t|
    t.integer  "study_id"
    t.integer  "user_id"
    t.string   "summary"
    t.string   "upload_file_name"
    t.string   "upload_content_type"
    t.integer  "upload_file_size"
    t.string   "result_file_name"
    t.string   "result_content_type"
    t.integer  "result_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subjects", :force => true do |t|
    t.string   "mrn"
    t.string   "mrn_type"
    t.string   "source_system"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "suffix"
    t.date     "birth_date"
    t.date     "death_date"
    t.string   "address_line1"
    t.string   "address_line2"
    t.string   "address_line3"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone_number"
    t.string   "email"
    t.datetime "synced_at"
    t.text     "pre_sync_data"
    t.boolean  "no_contact"
    t.text     "no_contact_reason"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subjects", ["mrn"], :name => "subjects_mrn_idx", :unique => true

  create_table "users", :force => true do |t|
    t.string   "netid"
    t.string   "email"
    t.string   "title"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "address_line1"
    t.string   "address_line2"
    t.string   "address_line3"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.string   "phone_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["netid"], :name => "users_netid_idx", :unique => true

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "versions_attr_idx"

end
