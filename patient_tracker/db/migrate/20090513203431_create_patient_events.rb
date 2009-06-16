class CreateSubjectEvents < ActiveRecord::Migration
  def self.up
    create_table :subject_events do |t|
      t.integer :subject_id, :not_null => true # Always needed
      t.string :status
      t.date :status_date
      t.integer :protocol_id #sometimes null if it's subject related and not around a protocol
      t.text :notes 
      t.timestamps
    end
  end

  def self.down
    drop_table :subject_events
  end
end
