class CreateInvolvements < ActiveRecord::Migration
  def self.up
    create_table :involvements do |t|
      t.integer :subject_id
      t.integer :protocol_id
      t.boolean :confirmed
      t.string :disease_site
      t.text :description
      t.timestamps
    end
  end

  def self.down
    drop_table :involvements
  end
end
