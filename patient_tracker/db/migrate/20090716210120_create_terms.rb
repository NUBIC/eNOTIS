class CreateTerms < ActiveRecord::Migration
  def self.up
    create_table :terms do |t|
      t.string :term
      t.string :code
      t.string :category
      t.string :source
      t.text :description
      t.timestamps
    end
    add_index(:terms, [:code, :category], :unique => true)
  end

  def self.down
    remove_index(:terms, [:code, :category])
    drop_table :terms
  end
end
