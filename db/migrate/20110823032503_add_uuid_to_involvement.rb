class AddUuidToInvolvement < ActiveRecord::Migration
  def self.up
    add_column :involvements, :uuid, :string, :limit => 36
  end

  def self.down
    remove_column :involvements, :uuid
  end
end
