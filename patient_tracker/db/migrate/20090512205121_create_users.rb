class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :netid
      t.string :email
      t.string :email_type

      t.string :title
      t.string :first_name
      t.string :last_name
      t.string :middle_name
      t.string :description

      t.string :address_line1
      t.string :address_line2
      t.string :address_line3
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :country
      t.string :address_description
      t.string :address_type

      t.string :training_id
      t.string :training_type_id
      t.string :training_type
      t.string :training_certification_date
      t.string :training_expiration_date

      t.string :phone_description
      t.string :phone_number
      t.string :phone_type

      t.string :fax_description
      t.string :fax_number
      t.string :fax_type
      
      t.datetime :eirb_create_date
      
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
