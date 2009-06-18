class CreateSubjectEvents < ActiveRecord::Migration
  def self.up
    create_table :subject_events do |t|
      t.integer :subject_id, :not_null => true # Always needed
      t.integer :study_id # sometimes null if it's subject related and not around a study
      t.string :event
      t.datetime :occured_at
      t.text :notes 
      t.timestamps
    end
  end

  def self.down
    drop_table :subject_events
  end
end
