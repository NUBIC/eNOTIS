class ImportResultsFields < ActiveRecord::Migration
  def self.up
    add_column :studies, :imported_at, :datetime
    add_column :studies, :import_errors, :boolean
    add_column :studies, :import_cache, :text 
  end

  def self.down
    remove_column :studies, :imported_at
    remove_column :studies, :import_errors
    remove_column :studies, :import_cache
  end
end
