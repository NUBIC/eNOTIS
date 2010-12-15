class EventTypeData < ActiveRecord::Migration
  def self.up
    # Add the column to the involvment events for clinical_event parent
    add_column(:involvement_events, :event_type_id, :integer)
    add_index(:involvement_events, :event_type_id)
    # Changing the name to avoid name collision with methods on the AR model
    rename_column(:involvement_events, :event, :name_of_event)
  end

  # Reverting and recreating the data
  def self.down
    # Drop the column for clinical_event
    remove_index(:involvement_events, :event_type_id)
    remove_column(:involvement_events, :event_type_id)
    #rename the column back to how it was
    rename_column(:involvement_events, :name_of_event, :event)
  end
end
