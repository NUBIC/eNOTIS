class CreatePatientProtocolsStatus < ActiveRecord::Migration
  def self.up
	create_table :patients_protocols do |t|
		t.integer :patient_id
		t.string :irb_number
		t.string :status
	
	end
  end

  def self.down
	drop table :patients_protocols
  end
end
