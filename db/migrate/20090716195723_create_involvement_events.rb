class CreateInvolvementEvents < ActiveRecord::Migration
  def self.up
    create_table :involvement_events do |t|
      t.integer :involvement_id
      t.integer :event_type_id
      t.date :occurred_at
      t.text :note 
      t.timestamps
    end

    # For oracle... indexes, sequences, tablenames, and columnames must be less than 30 characters... had to rename this one from the default generated one
    add_index(:involvement_events, [:involvement_id,:event_type_id,:occurred_at], :name => 'inv_events_attr_idx', :unique => true) # Should cover most queries
    add_index(:involvement_events, :occurred_at, :unique => false, :name => 'inv_events_occurred_idx') # For date based queries
    add_index(:involvement_events, :event_type_id, :unique => false, :name => 'inv_events_type_idx') # For event_type querien
  end

  def self.down
    remove_index(:involvement_events, :name => 'inv_events_attr_idx')
    remove_index(:involvement_events, :name => 'inv_events_occurred_idx')
    remove_index(:involvement_events, :name => 'inv_events_type_idx')
    drop_table :involvement_events
  end
end
