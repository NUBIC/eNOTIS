class CreateInvolvementEvents < ActiveRecord::Migration
  def self.up
    create_table :involvement_events do |t|
      t.integer :involvement_id
      t.integer :event_type_id
      t.date :occurred_on
      t.text :note 
      t.timestamps
    end

    add_index(:involvement_events, [:involvement_id,:event_type_id,:occurred_on], :name => 'inv_events_attr_idx', :unique => true) # Should cover most queries
    add_index(:involvement_events, :occurred_on, :unique => false, :name => 'inv_events_occurred_idx') # For date based queries
    add_index(:involvement_events, :event_type_id, :unique => false, :name => 'inv_events_type_idx') # For event_type querien
  end

  def self.down
    remove_index(:involvement_events, :name => 'inv_events_attr_idx')
    remove_index(:involvement_events, :name => 'inv_events_occurred_idx')
    remove_index(:involvement_events, :name => 'inv_events_type_idx')
    drop_table :involvement_events
  end
end
