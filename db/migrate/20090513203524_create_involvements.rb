class CreateInvolvements < ActiveRecord::Migration
  def self.up
    create_table :involvements do |t|
      t.integer :subject_id
      t.integer :study_id
      t.string  :ethnicity
      t.string  :gender
      t.string  :race
      t.string  :case_number
      t.timestamps
    end
    add_index(:involvements, [:subject_id, :study_id, :ethnicity, :gender], :name => 'involvements_attr_idx', :unique => true)
  end

  def self.down
    remove_index(:involvements,:name => 'involvements_attr_idx')
    drop_table :involvements
  end
end
