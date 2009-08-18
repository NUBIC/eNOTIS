class CreateRaces < ActiveRecord::Migration
  def self.up
    create_table :races do |t|
      t.integer :involvement_id
      t.integer :race_type_id
      t.timestamps
    end
    add_index(:races, [:involvement_id, :race_type_id], :name => 'races_attr_idx', :unique => true) # Should be duplicating the same race per involvement
  end

  def self.down
    remove_index(:races, :name => 'races_attr_idx')
    drop_table :races
  end
end
