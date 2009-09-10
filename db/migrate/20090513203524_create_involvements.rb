class CreateInvolvements < ActiveRecord::Migration
  def self.up
    create_table :involvements do |t|
      t.integer :subject_id
      t.integer :study_id
      t.integer :ethnicity_type_id
      t.integer :gender_type_id
      t.string  :case_number
      t.timestamps
    end
    
    add_index(:involvements, [:subject_id, :study_id, :ethnicity_type_id, :gender_type_id], :name => 'involvements_attr_idx', :unique => true)
  end

  def self.down
    remove_index(:involvements,:name => 'involvements_attr_idx')
    drop_table :involvements
  end
end
