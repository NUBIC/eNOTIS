class CreateProtocols < ActiveRecord::Migration
  def self.up
    create_table :protocols, :id => false, :primary_key => :irb_number do |t|
      t.string :irb_number
      t.timestamps
    end
  end

  def self.down
    drop_table :protocols
  end
end
