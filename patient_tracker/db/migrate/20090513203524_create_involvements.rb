class CreateInvolvements < ActiveRecord::Migration
  def self.up
    create_table :involvements do |t|
      t.integer :subject_id
      t.integer :study_id
      t.timestamps
    end

    add_index(:involvements, [:subject_id, :study_id], :unique => true)
  end

  def self.down
    remove_index(:involvements,[:subject_id, :study_id])
    drop_table :involvements
  end
end
