class CreateProtocols < ActiveRecord::Migration
  def self.up
        create_table :protocols do |t|
                t.string :eirb_number
        end
	
  end

  def self.down
	drop_table :protocols
  end
end
