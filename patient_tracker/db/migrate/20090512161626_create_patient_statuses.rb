class CreatePatientStatuses < ActiveRecord::Migration
  def self.up
    create_table :patient_statuses do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :patient_statuses
  end
end
