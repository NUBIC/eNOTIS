
class CreateEventTypes < ActiveRecord::Migration
  def self.up
    create_table :event_types do |t|
      t.string :name
      t.string :description
      t.string :time_span, :default => 'point' #point or period - Defines if this is single day event (point) or multiple days
      t.integer :seq, :default => 0 # Used to display events in the dropdowns and UI
      t.integer :study_id
      t.boolean :editable, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :event_types
  end
end

