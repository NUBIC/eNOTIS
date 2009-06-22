class CreateCoordinators < ActiveRecord::Migration
  def self.up
    create_table :coordinators do |t|
      t.integer :study_id
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :coordinators
  end
end
