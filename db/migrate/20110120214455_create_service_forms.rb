class CreateServiceForms < ActiveRecord::Migration
  def self.up
  	create_table :service_forms do |t|
  	  t.integer :study_id
      t.boolean :uses_medical_services
      t.integer :current_enrollment
      t.integer :expected_enrollment
      t.integer :expected_services
      t.boolean :requires_outpatient
      t.boolean :requires_inpatient
      t.integer :inpatient_days_research
      t.integer :inpatient_days_standard
      t.boolean :involves_pharmacy
      t.boolean :involves_labs
      t.boolean :involves_imaging
      t.string  :contact_name
      t.string  :contact_email
      t.string  :contact_phone
    end
  end
  def self.down
    drop_table :service_forms
  end
end
