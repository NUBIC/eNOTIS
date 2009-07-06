class CreateStudies < ActiveRecord::Migration
  def self.up
    create_table :studies do |t|
      t.string :irb_number
      t.string :name
      t.string :title
      t.string :phase
      t.string :research_type
      t.string :description
      t.string :status
      t.string :pi_netid
      t.string :pi_first_name
      t.string :pi_last_name
      t.string :pi_email
      t.string :sc_netid
      t.string :sc_first_name
      t.string :sc_last_name
      t.string :sc_email

      t.datetime :synced_at
      t.timestamps
    end
  end

  def self.down
    drop_table :studies
  end
end
