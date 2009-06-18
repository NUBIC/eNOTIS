class CreateUserAccessRights < ActiveRecord::Migration
  def self.up
    create_table :user_access_rights do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :user_access_rights
  end
end
