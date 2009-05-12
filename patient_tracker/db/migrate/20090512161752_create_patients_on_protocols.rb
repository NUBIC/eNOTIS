class CreatePatientsOnProtocols < ActiveRecord::Migration
  def self.up
    create_table :patients_on_protocols do |t|
      t.integer :patient_id
      t.integer :protocol_id
      t.integer :patient_on_protocol_status_id
      t.timestamps
    end
  end

  def self.down
    drop_table :patients_on_protocols
  end
end
