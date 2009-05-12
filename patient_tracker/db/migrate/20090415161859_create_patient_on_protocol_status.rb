class CreatePatientOnProtocolStatus < ActiveRecord::Migration
  def self.up
	create_table :patient_on_protocol_status do |t|
		t.integer :patient_on_protocol_id
		t.string  :status
		t.date	  :start_date
	end
  end

  def self.down
	drop_table :patient_protocol_status
  end
end
