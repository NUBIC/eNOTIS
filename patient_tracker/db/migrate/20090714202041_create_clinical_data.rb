class CreateClinicalData < ActiveRecord::Migration
  def self.up
    create_table :clinical_data do |t|
      t.string :type #for sti
      t.string :key
      t.string :value
      t.datetime :occured_at
      t.timestamps
    end
    add_index(:clinical_data, [:type, :key])
  end

  def self.down
    remove_index(:clinical_data, [:type, :key])
    drop_table :clinical_data
  end
end
