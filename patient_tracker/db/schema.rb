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

ActiveRecord::Schema.define(:version => 20090512161752) do

  create_table "patient_on_protocol_status", :force => true do |t|
    t.integer "patient_on_protocol_id"
    t.string  "status"
    t.date    "start_date"
  end

  create_table "patients", :force => true do |t|
    t.string "mrd_pt_id"
    t.string "type"
    t.string "mrn"
    t.string "mrn_type"
    t.string "last_name"
    t.string "first_name"
    t.date   "birth_date"
    t.date   "death_date"
    t.string "address_line1"
    t.string "address_line2"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "phone"
    t.string "work_phone"
    t.string "work_phone_extension"
  end

  create_table "patients_on_protocols", :force => true do |t|
    t.integer  "patient_id"
    t.integer  "protocol_id"
    t.integer  "patient_on_protocol_status_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "protocols", :force => true do |t|
    t.string "irb_number"
  end

end
