class CreateResourceStatuses < ActiveRecord::Migration
  def self.up
    create_table :resource_statuses do |t|
      t.string :name,:null=>false
      t.boolean :status
      t.string :message
      t.timestamps
    end
  end

  def self.down
     drop_table :resource_statuses
  end
end
