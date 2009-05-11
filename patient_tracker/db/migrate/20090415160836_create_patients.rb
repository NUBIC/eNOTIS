class CreatePatients < ActiveRecord::Migration
  def self.up
	create_table :patients do |t|
		t.string :mrd_pt_id
		t.string :last_name
		t.string :first_name
		t.date   :birth_date
	end
  end

  def self.down
	drop_table :patients
  end
end
