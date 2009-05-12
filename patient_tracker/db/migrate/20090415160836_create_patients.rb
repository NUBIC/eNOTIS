class CreatePatients < ActiveRecord::Migration
  def self.up
	create_table :patients do |t|
		t.string :mrd_pt_id
    t.string :type # For Rails STI		
    t.string :mrn
    t.string :mrn_type
    t.string :last_name
		t.string :first_name
		t.date   :birth_date
    t.string :address_line1
    t.string :address_line2
    t.string :city
    t.string :state
    t.string :zip
    t.string :phone
    t.string :work_phone
    t.string :work_phone_extension
	end
  end

  def self.down
	drop_table :patients
  end
end
