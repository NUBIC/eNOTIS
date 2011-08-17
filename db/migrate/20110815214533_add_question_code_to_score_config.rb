class AddQuestionCodeToScoreConfig < ActiveRecord::Migration
  def self.up
    add_column :score_configurations, :question_code, :string
  end

  def self.down
    remove_column :score_configurations, :question_code
  end
end
