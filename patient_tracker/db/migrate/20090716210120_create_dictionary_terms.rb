class CreateDictionaryTerms < ActiveRecord::Migration
  def self.up
    create_table :dictionary_terms do |t|
      t.string :term
      t.string :code
      t.string :category
      t.string :source
      t.text :description
      t.timestamps
    end
    add_index(:dictionary_terms, [:code, :category], :unique => true)
  end

  def self.down
    remove_index(:dictionary_terms, [:code, :category])
    drop_table :dictionary_terms
  end
end
