class AddScoringTables < ActiveRecord::Migration
  def self.up
    create_table :score_configurations do |t|
      t.string :name
      t.string :algorithm
      t.integer :survey_id
    end

    create_table :scores do |t|
      t.integer :score_configuration_id
      t.integer :response_set_id
      t.float   :value
    end
  end

  def self.down
    drop_table :score_configurations
    drop_table :scores
  end
end
