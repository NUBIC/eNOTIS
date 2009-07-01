class CreateInvolvementEvents < ActiveRecord::Migration
  def self.up
    create_table :involvement_events do |t|
      t.integer :involvement_id
      t.string :type 
      t.date :event_date 
      t.timestamps
    end
  end

  def self.down
    drop_table :involvement_events
  end
end
