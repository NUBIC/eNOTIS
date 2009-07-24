class CreateCoordinators < ActiveRecord::Migration
  def self.up
    create_table :coordinators do |t|
      t.integer :study_id
      t.integer :user_id
      t.timestamps
    end

    add_index(:coordinators, [:study_id, :user_id], :unique => true)
  end

  def self.down
    remove_index(:coordinators, [:study_id, :user_id])
    drop_table :coordinators
  end
end
