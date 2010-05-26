class RemovalOfResorceStatus < ActiveRecord::Migration
  
  # Models have been removed. We  are no longer using this table to handle tracking if a service
  # is up or down.
  def self.up
    drop_table :resource_statuses
  end

  def self.down
    create_table :resource_statuses do |t|
      t.string :name,:null=>false
      t.boolean :status
      t.string :message
      t.timestamps
    end
  end
end
