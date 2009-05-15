class CreateInvolvements < ActiveRecord::Migration
  def self.up
    create_table :involvements do |t|
      t.integer :patient_id
      t.integer :protocol_id
      t.string :disease_site
      t.text :description
      t.timestamps
    end
  end

  def self.down
    drop_table :involvements
  end
end