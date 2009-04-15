class CreatePatients < ActiveRecord::Migration
  def self.up
	create_table :patients do |t|
		t.string :last_name
		t.string :first_name
		t.string :middle_name
		t.string :name_suffix
		t.string :name_prefix
		t.string :home_address_1
		t.string :home_address_2
		t.string :home_city
		t.string :home_state
		t.string :home_phone
		t.string :mobile_phone
		t.string :business_phone
		t.string :other_phone
		t.string :email
		t.string :sex
		t.string :gender
		t.string :race
		t.string :ethnicity
		t.string :jewish_heritage
		t.date   :birth_date
		t.date 	 :death_date
		t.string :cause_of_death
	end
  end

  def self.down
	drop_table :patients
  end
end
