class CreateRaces < ActiveRecord::Migration
  def self.up
    create_table :races do |t|
      t.integer :race_type_id
      t.timestamps
    end
    add_index(:races, :race_type_id)
  end

  def self.down
    remove_index(:races, :race_type_id)
    drop_table :races
  end
end
