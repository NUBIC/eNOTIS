class AddNetidToUserAssociations < ActiveRecord::Migration
  def self.up
    add_column :roles, :netid, :string 
    add_column :study_uploads, :netid, :string 
  end

  def self.down
    remove_column :roles, :netid
    remove_column :study_uploads, :netid
  end
end
