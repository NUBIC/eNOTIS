class CreateStudies < ActiveRecord::Migration
  def self.up
    create_table :studies do |t|
      t.string :irb_number
      t.string :name
      t.string :title
      t.string :phase
      t.string :description
      t.string :status
      t.datetime :synced_at
      t.timestamps
    end
  end

  def self.down
    drop_table :studies
  end
end
