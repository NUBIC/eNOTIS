class CreateSubjects < ActiveRecord::Migration
  def self.up
  	create_table :subjects do |t|
      t.string :mrn 
      t.string :mrn_type #nmff or nmh
      t.string :source_system #notis, enotis, edw, or other auto-registry system
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :suffix #Jr., III, etc...
      t.date   :birth_date
      t.date   :death_date 
      t.string :address_line1
      t.string :address_line2
      t.string :address_line3
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone_number
      t.string :email
      t.datetime :synced_at
      t.text :pre_sync_data #holds data copied out of the model before we locked this record with the MR
      t.boolean :no_contact
      t.text :no_contact_reason
      t.timestamps
    end

    add_index(:subjects, :mrn, :unique => true)
  end

  def self.down
    remove_index(:subjects, :mrn)
    drop_table :subjects
  end
end
