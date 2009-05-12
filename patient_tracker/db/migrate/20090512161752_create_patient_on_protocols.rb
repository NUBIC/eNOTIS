class CreatePatientOnProtocols < ActiveRecord::Migration
  def self.up
    create_table :patient_on_protocols do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :patient_on_protocols
  end
end
