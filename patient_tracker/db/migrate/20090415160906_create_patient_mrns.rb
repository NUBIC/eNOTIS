class CreatePatientMrns < ActiveRecord::Migration
  def self.up
	create_table :patient_mrns do |t|
		t.integer :patient_id
		t.string :mrn_type
		t.string :mrn
	end
  end

  def self.down
	drop_table :patient_mrns
  end
end
