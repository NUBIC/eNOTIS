class CreatePatientOnProtocols < ActiveRecord::Migration
  def self.up
    create_table :patient_on_protocols do |t|
      t.integer :patient_id
      t.integer :protocol_id
      t.timestamps
    end
  end

  def self.down
    drop_table :patient_on_protocols
  end
end
