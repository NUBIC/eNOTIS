class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :netid
      t.string :email
      t.string :title
      t.string :first_name
      t.string :middle_name
      t.string :last_name 
      t.string :address_line1
      t.string :address_line2
      t.string :address_line3
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.string :phone_number
      t.timestamps
    end
    
    # adding netid index
    add_index(:users, :netid, :unique => true )
  end

  def self.down
    remove_index(:users, :netid)
    drop_table :users
  end
end
