class AddSurveyGroups < ActiveRecord::Migration
  def self.up
    create_table :survey_groups do |t|
      t.string :access_code
      t.string :title
      t.string :progression
    end
    add_column :surveys, :survey_group_id, :integer
    add_column :surveys, :display_order, :integer
  end

  def self.down
    drop_table :survey_groups
    remove_column :surveys, :survey_group_id
    remove_column :surveys, :display_order
  end
end
