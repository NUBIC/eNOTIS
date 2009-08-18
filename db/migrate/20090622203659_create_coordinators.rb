class CreateCoordinators < ActiveRecord::Migration
  def self.up
    create_table :coordinators do |t|
      t.integer :study_id
      t.integer :user_id
      t.timestamps
    end
    # For oracle... indexes, sequences, tablenames, and columnames must be less than 30 characters... had to rename this one from the default generated one
    add_index(:coordinators, [:study_id, :user_id], :name => 'coordinators_attr_idx',:unique => true)
  end

  def self.down
    remove_index(:coordinators, :name => 'coordinators_attr_idx')
    drop_table :coordinators
  end
end
