class AddColumnsToStudies < ActiveRecord::Migration
  def self.up
    add_column :studies, :review_type_requested, :string
    add_column :studies, :fda_unapproved_agent, :string
    add_column :studies, :fda_offlabel_agent, :string
    add_column :studies, :accrual_goal, :integer
    add_column :studies, :expired_date, :datetime
    add_column :studies, :clinical_trial_submitter, :string
    add_column :studies, :created_date, :string
    add_column :studies, :is_a_clinical_investigation, :bool
    add_column :studies, :modified_date, :datetime
    add_column :studies, :multi_inst_study, :boolean
    add_column :studies, :periodic_review_open, :boolean
    add_column :studies, :subject_expected_completion_count, :integer
    add_column :studies, :total_subjects_at_all_ctrs, :integer
    add_column :studies, :inclusion_criteria, :text
    add_column :studies, :exclusion_criteria, :text
    add_column :studies, :description, :text
    rename_table :authorized_people, :roles
    # drop_table :principal_investigators
    # drop_table :co_investigators
    # drop_table :coordinators
    #TODO: check foreign key cascading at some later date
  end

  def self.down
    # create_table "coordinators", :force => true do |t|
    #   t.integer  "study_id"
    #   t.integer  "user_id"
    #   t.datetime "created_at"
    #   t.datetime "updated_at"
    # end
    # 
    # create_table "co_investigators", :force => true do |t|
    #   t.integer  "study_id"
    #   t.integer  "user_id"
    #   t.datetime "created_at"
    #   t.datetime "updated_at"
    # end
    # 
    # create_table "principal_investigators", :force => true do |t|
    #   t.integer  "study_id"
    #   t.integer  "user_id"
    #   t.datetime "created_at"
    #   t.datetime "updated_at"
    # end
    
    rename_table :roles, :authorized_people
    remove_column :studies, :description
    remove_column :studies, :exclusion_criteria
    remove_column :studies, :inclusion_criteria
    remove_column :studies, :total_subjects_at_all_ctrs
    remove_column :studies, :subject_expected_completion_count
    remove_column :studies, :periodic_review_open
    remove_column :studies, :multi_inst_study
    remove_column :studies, :modified_date
    remove_column :studies, :is_a_clinical_investigation
    remove_column :studies, :created_date
    remove_column :studies, :clinical_trial_submitter
    remove_column :studies, :expired_date
    remove_column :studies, :accrual_goal
    remove_column :studies, :fda_offlabel_agent
    remove_column :studies, :fda_unapproved_agent
    remove_column :studies, :review_type_requested
  end
end
