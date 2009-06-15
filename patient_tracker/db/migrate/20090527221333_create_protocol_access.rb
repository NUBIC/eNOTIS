class CreateProtocolAccess < ActiveRecord::Migration
  def self.up
    create_table :protocol_access do |t|
      t.integer :user_id
      t.integer :protocol_id
      t.string  :role
      t.date :reconciliation_date
      t.string :reconciliation_status
      t.timestamps
    end

  end

  def self.down
    drop_table :user_protocols
  end
end
