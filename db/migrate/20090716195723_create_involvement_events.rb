class CreateInvolvementEvents < ActiveRecord::Migration
  def self.up
    create_table :involvement_events do |t|
      t.integer :involvement_id
      t.date :occured_at
      t.integer :event_type_id
      t.text :note 
      t.timestamps
    end
    add_index(:involvement_events, :involvement_id)
    add_index(:involvement_events, :event_type_id) 
  end

  def self.down
    remove_index(:involvement_events, :involvement_id)
    remove_index(:involvement_events, :event_type_id)
    drop_table :involvement_events
  end
end
