class CreateStudies < ActiveRecord::Migration
  def self.up
    create_table :studies do |t|
      t.string :irb_number
      t.string :name
      t.text :title
      t.string :phase
      t.string :research_type
      t.text :description
      t.text :accrual_goal
      t.datetime :approved_date
      t.datetime :expiration_date
      t.boolean :multi_inst_study
      t.boolean :periodic_review_open
      t.string :irb_status
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

    add_index(:studies, :irb_number, :unique => true, :name => 'studies_irb_number_idx')
  end

  def self.down
    remove_index(:studies, :name => 'studies_irb_number_idx')
    drop_table :studies
  end
end
