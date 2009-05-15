class CreateProtocols < ActiveRecord::Migration
  def self.up
    create_table :protocols do |t|
      t.string :irb_number
      t.string :title
      t.string :description
      t.string :approval_status
      t.date :reconciliation_date
      t.string :reconciliation_status
      t.timestamps
    end
  end

  def self.down
    drop_table :protocols
  end
end
