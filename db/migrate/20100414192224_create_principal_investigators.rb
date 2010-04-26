class CreatePrincipalInvestigators < ActiveRecord::Migration
  def self.up
    create_table :principal_investigators do |t|
      t.integer :study_id
      t.integer :user_id
      t.timestamps
    end
    add_index(:principal_investigators, [:study_id, :user_id], :name => 'principal_investigators_attr_idx',:unique => true)
  end

  def self.down
    remove_index(:principal_investigators, :name => 'principal_investigators_attr_idx')
    drop_table :principal_investigators
  end
end
