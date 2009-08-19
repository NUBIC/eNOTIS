
ActiveRecord::Schema.define(:version => 20090717213941) do

  table "activities" do |t|
    t.string   "controller"
    t.string   "action"
    t.text     "params"
    t.string   "whodunnit"
    t.datetime "created_at"
  end

  table "activity_items" do |t|
    t.integer "activity_id"
    t.string  "key"
    t.text    "value"
  end

  table "coordinators" do |t|
    t.integer  "study_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  index "coordinators", ["study_id", "user_id"], :name => "index_coordinators_on_study_id_and_user_id", :unique => true

  table "dictionary_terms" do |t|
    t.string   "term"
    t.string   "code"
    t.string   "category"
    t.string   "source"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  index "dictionary_terms", ["code", "category"], :name => "index_dictionary_terms_on_code_and_category", :unique => true

  table "involvement_events" do |t|
    t.integer  "involvement_id"
    t.datetime "occurred_on"
    t.integer  "event_type_id"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  index "involvement_events", ["event_type_id"], :name => "index_involvement_events_on_event_type_id"
  index "involvement_events", ["involvement_id"], :name => "index_involvement_events_on_involvement_id"

  table "involvements" do |t|
    t.integer  "subject_id"
    t.integer  "study_id"
    t.integer  "ethnicity_type_id"
    t.integer  "gender_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  index "involvements", ["subject_id", "study_id", "ethnicity_type_id", "gender_type_id"], :name => "index_involvements_on_subject_id_and_study_id_and_ethnicity_type_id_and_gender_type_id", :unique => true

  table "races" do |t|
    t.integer  "involvement_id"
    t.integer  "race_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  index "races", ["involvement_id"], :name => "index_races_on_involvement_id"
  index "races", ["race_type_id"], :name => "index_races_on_race_type_id"

  table "studies" do |t|
    t.string   "irb_number"
    t.string   "name"
    t.string   "title"
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
  index "studies", ["irb_number"], :name => "index_studies_on_irb_number", :unique => true

  table "study_uploads" do |t|
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

  table "subjects" do |t|
    t.string   "mrn"
    t.string   "mrn_type"
    t.string   "source_system"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "postfix"
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
  index "subjects", ["mrn"], :name => "index_subjects_on_mrn", :unique => true

  table "users" do |t|
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
  index "users", ["netid"], :name => "index_users_on_netid", :unique => true

  table "versions" do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end
  index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end
