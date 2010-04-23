class CreateCoInvestigators < ActiveRecord::Migration
  def self.up
    create_table :co_investigators do |t|
      t.integer :study_id
      t.integer :user_id
      t.timestamps
    end
    add_index(:co_investigators, [:study_id, :user_id], :name => 'co_investigators_attr_idx',:unique => true)
  end

  def self.down
    remove_index(:co_investigators, :name => 'principal_investigators_attr_idx')
    drop_table :co_investigators
  end
end
