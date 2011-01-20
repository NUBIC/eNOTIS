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

ActiveRecord::Schema.define(:version => 20110120214511) do

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

  create_table "dictionary_terms", :force => true do |t|
    t.string   "term"
    t.string   "code"
    t.string   "category"
    t.string   "source"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  # unrecognized index "dictionary_attr_idx" with type ActiveRecord::ConnectionAdapters::IndexDefinition

  create_table "event_types", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "time_span",   :default => "point"
    t.integer  "seq",         :default => 0
    t.integer  "study_id"
    t.boolean  "editable",    :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "funding_sources", :force => true do |t|
    t.integer  "study_id"
    t.string   "name"
    t.string   "code"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "involvement_events", :force => true do |t|
    t.integer  "involvement_id"
    t.date     "occurred_on"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_type_id"
  end

  # unrecognized index "index_involvement_events_on_event_type_id" with type ActiveRecord::ConnectionAdapters::IndexDefinition
  # unrecognized index "inv_events_occurred_idx" with type ActiveRecord::ConnectionAdapters::IndexDefinition

  create_table "involvements", :force => true do |t|
    t.integer  "subject_id"
    t.integer  "study_id"
    t.string   "ethnicity"
    t.string   "gender"
    t.string   "case_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "race_is_native_hawaiian_or_other_pacific_islander", :default => false
    t.boolean  "race_is_white",                                     :default => false
    t.boolean  "race_is_unknown_or_not_reported",                   :default => false
    t.boolean  "race_is_american_indian_or_alaska_native",          :default => false
    t.boolean  "race_is_asian",                                     :default => false
    t.boolean  "race_is_black_or_african_american",                 :default => false
    t.string   "address_line1"
    t.string   "address_line2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "email"
    t.string   "home_phone"
    t.string   "work_phone"
    t.string   "cell_phone"
  end

  # unrecognized index "involvements_attr_idx" with type ActiveRecord::ConnectionAdapters::IndexDefinition

  create_table "races", :force => true do |t|
    t.integer  "involvement_id"
    t.integer  "race_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  # unrecognized index "races_attr_idx" with type ActiveRecord::ConnectionAdapters::IndexDefinition

  create_table "roles", :force => true do |t|
    t.integer  "study_id"
    t.integer  "user_id"
    t.string   "project_role"
    t.string   "consent_role"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "netid"
  end

  # unrecognized index "index_authorized_people_on_consent_role" with type ActiveRecord::ConnectionAdapters::IndexDefinition
  # unrecognized index "index_authorized_people_on_project_role" with type ActiveRecord::ConnectionAdapters::IndexDefinition
  # unrecognized index "index_authorized_people_on_study_id" with type ActiveRecord::ConnectionAdapters::IndexDefinition
  # unrecognized index "index_authorized_people_on_user_id" with type ActiveRecord::ConnectionAdapters::IndexDefinition
  # unrecognized index "roles_netid_idx" with type ActiveRecord::ConnectionAdapters::IndexDefinition

  create_table "service_procedures", :force => true do |t|
    t.integer "service_report_id"
    t.string  "name"
    t.integer "times"
    t.string  "location"
    t.string  "bill_to"
  end

  create_table "service_reports", :force => true do |t|
    t.integer "study_id"
    t.boolean "uses_medical_services"
    t.integer "current_enrollment"
    t.integer "expected_enrollment"
    t.integer "expected_services"
    t.boolean "requires_outpatient"
    t.boolean "requires_inpatient"
    t.integer "inpatient_days_research"
    t.integer "inpatient_days_standard"
    t.boolean "involves_pharmacy"
    t.boolean "involves_labs"
    t.boolean "involves_imaging"
    t.string  "contact_name"
    t.string  "contact_email"
    t.string  "contact_phone"
  end

  create_table "studies", :force => true do |t|
    t.string   "irb_number"
    t.string   "irb_status"
    t.string   "name"
    t.text     "title"
    t.datetime "approved_date"
    t.datetime "closed_or_completed_date"
    t.datetime "expiration_date"
    t.string   "research_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "review_type_requested"
    t.string   "fda_unapproved_agent"
    t.string   "fda_offlabel_agent"
    t.integer  "accrual_goal"
    t.datetime "expired_date"
    t.string   "clinical_trial_submitter"
    t.string   "created_date"
    t.boolean  "is_a_clinical_investigation"
    t.datetime "modified_date"
    t.boolean  "multi_inst_study"
    t.boolean  "periodic_review_open"
    t.integer  "subject_expected_completion_count"
    t.integer  "total_subjects_at_all_ctrs"
    t.text     "inclusion_criteria"
    t.text     "exclusion_criteria"
    t.text     "description"
    t.boolean  "read_only"
    t.string   "read_only_msg"
    t.boolean  "uses_medical_services"
    t.datetime "medical_services_update_at"
  end

  # unrecognized index "studies_irb_number_idx" with type ActiveRecord::ConnectionAdapters::IndexDefinition

  create_table "study_uploads", :force => true do |t|
    t.integer  "study_id"
    t.integer  "user_id"
    t.string   "state"
    t.string   "summary"
    t.string   "upload_file_name"
    t.string   "upload_content_type"
    t.integer  "upload_file_size"
    t.string   "result_file_name"
    t.string   "result_content_type"
    t.integer  "result_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "netid"
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
    t.integer  "external_patient_id"
    t.string   "data_source"
    t.date     "empi_updated_date"
    t.string   "nmff_mrn"
    t.string   "nmh_mrn"
    t.string   "ric_mrn"
  end

  # unrecognized index "index_subjects_on_external_patient_id" with type ActiveRecord::ConnectionAdapters::IndexDefinition

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

  # unrecognized index "users_netid_idx" with type ActiveRecord::ConnectionAdapters::IndexDefinition

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  # unrecognized index "versions_attr_idx" with type ActiveRecord::ConnectionAdapters::IndexDefinition

end
