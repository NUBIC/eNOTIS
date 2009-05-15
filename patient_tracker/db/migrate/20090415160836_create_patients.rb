class CreatePatients < ActiveRecord::Migration
  def self.up
  	create_table :patients do |t|
      t.string :mrn 
      t.string :mrn_type
      t.string :source
      t.date :last_reconciled
      t.string :reconcile_status
      t.string :last_name
  		t.string :first_name
      t.boolean :lost_to_follow_up
      t.text :lost_to_follow_up_reason
  		t.date   :birth_date
      t.date   :death_date 
      t.string :address_line1
      t.string :address_line2
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone
      t.string :work_phone
      t.string :work_phone_extension
      t.text :xml_node
       t.timestamps
    end
  end

  def self.down
    drop_table :patients
  end
end
