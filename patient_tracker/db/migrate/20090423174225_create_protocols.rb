class CreateProtocols < ActiveRecord::Migration
  def self.up
    create_table :protocols do |t|
      t.string :irb_number
      t.string :name
      t.string :title
      t.string :phase
      t.string :description
      t.string :status
      t.date :reconciliation_date
      t.timestamps
    end
  end

  def self.down
    drop_table :protocols
  end
end
