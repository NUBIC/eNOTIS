class CreateSubjects < ActiveRecord::Migration
  def self.up
  	create_table :subjects do |t|
      t.string :mrn 
      t.string :mrn_type
      t.string :source
      # t.datetime :last_reconciled
      # t.string :reconcile_status
      t.datetime :synced_at
      t.text :pre_sync_data
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
       t.timestamps
    end

    add_index(:subjects, :mrn, :unique => true)
  end

  def self.down
    remove_index(:subjects, :mrn)
    drop_table :subjects
  end
end
