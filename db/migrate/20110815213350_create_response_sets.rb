class CreateResponseSets < ActiveRecord::Migration
  def self.up
    create_table :response_sets do |t|
      # Context
      t.integer :involvement_id
      t.integer :survey_id

      t.date :effective_date

      # Content
      t.string :access_code #unique id for the object used in urls

      # Expiry
      t.datetime :started_at
      t.datetime :completed_at

      t.timestamps
    end
  end

  def self.down
    drop_table :response_sets
  end
end
