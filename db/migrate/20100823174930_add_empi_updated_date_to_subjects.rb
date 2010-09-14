class AddEmpiUpdatedDateToSubjects < ActiveRecord::Migration
  def self.up
    add_column :subjects, :empi_updated_date, :date
  end

  def self.down
    remove_column :subjects, :empi_updated_date
  end
end
