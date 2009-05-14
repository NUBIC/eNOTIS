class CreatePatientEvents < ActiveRecord::Migration
  def self.up
    create_table :patient_events do |t|
      t.integer :protocol_id
      t.string :status
      t.date :status_date
      t.integer :patient_id
      t.timestamps
    end
  end

  def self.down
    drop_table :patient_events
  end
end
