class CreateCoordinations < ActiveRecord::Migration
  def self.up
    create_table :coordinations do |t|
      t.integer :study_id
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :coordinations
  end
end
