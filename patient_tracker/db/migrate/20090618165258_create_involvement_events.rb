class CreateInvolvementEvents < ActiveRecord::Migration
  def self.up
    create_table :involvement_events do |t|
      t.integer :involvement_id
      t.integer :created_by_id
      t.integer :updated_by_id
      t.string :description
      t.string :type # for single table inheritance
      t.date :event_date 
      t.timestamps
    end
  end

  def self.down
    drop_table :involvement_events
  end
end
