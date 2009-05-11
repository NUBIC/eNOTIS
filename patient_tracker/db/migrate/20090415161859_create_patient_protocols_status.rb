class CreatePatientProtocolsStatus < ActiveRecord::Migration
  def self.up
	create_table :patients_protocols_status do |t|
		t.integer :patient_protocol_id
		t.string  :status
		t.date	  :start_date
	end
  end

  def self.down
	drop_table :patients_protocols_status
  end
end
