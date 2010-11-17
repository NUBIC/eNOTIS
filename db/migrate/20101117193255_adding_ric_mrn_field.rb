class AddingRicMrnField < ActiveRecord::Migration
  def self.up
    add_column(:subjects, :ric_mrn, :string)
  end

  def self.down
    remove_column(:subjects, :ric_mrn)
  end
end
