class AddUuidToInvolvement < ActiveRecord::Migration
  def self.up
    add_column :involvements, :uuid, :string, :limit => 36
    add_index(:involvements, :uuid,:name=>'involvements_uuid_idx',:unique => true)
  end

  def self.down
    remove_index(:involvements, :name => 'involvements_uuid_idx')
    remove_column :involvements, :uuid
  end
end
