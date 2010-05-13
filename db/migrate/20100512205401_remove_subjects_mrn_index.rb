class RemoveSubjectsMrnIndex < ActiveRecord::Migration
  def self.up
    remove_index(:subjects, :name => 'subjects_mrn_idx')
  end

  def self.down
    add_index(:subjects, :mrn, :unique => true, :name => 'subjects_mrn_idx')
  end
end
