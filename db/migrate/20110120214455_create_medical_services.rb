class CreateMedicalServices < ActiveRecord::Migration
  def self.up
  	create_table :medical_services do |t|
  	  t.integer :study_id
      t.boolean :uses_services_before_completed
      t.integer :current_enrollment
      t.integer :expected_enrollment
      t.integer :expected_clinical_services
      t.boolean :expects_bedded_outpatients
      t.boolean :expects_bedded_inpatients
      t.integer :bedded_inpatient_days_research
      t.integer :bedded_inpatient_days_standard_care
      t.boolean :involves_pharmacy
      t.boolean :involves_labs_pathology
      t.boolean :involves_imaging
      t.string  :contact_name
      t.string  :contact_email
      t.string  :contact_phone
      t.datetime :completed_at
      t.timestamps
    end
  end
  def self.down
    drop_table :medical_services
  end
end
