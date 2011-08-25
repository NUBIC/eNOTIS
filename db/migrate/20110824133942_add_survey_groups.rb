class AddSurveyGroups < ActiveRecord::Migration
  def self.up
    create_table :survey_groups do |t|
      t.string :access_code
      t.string :title
      t.string :progression
    end
    add_column :surveys, :survey_group_id, :integer
  end

  def self.down
    drop_table :survey_groups
    remove_column :surveys, :survey_group_id
  end
end
