class CreateStudyRights < ActiveRecord::Migration
  def self.up
    create_table :study_rights do |t|
      t.integer :user_id
      t.integer :study_id
      t.string  :role
      t.date :reconciliation_date
      t.string :reconciliation_status
      t.timestamps
    end

  end

  def self.down
    drop_table :study_rights
  end
end
