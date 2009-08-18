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

    add_index(:dictionary_terms, [:code, :category], :name => 'dictionary_attr_idx', :unique => true)
  end

  def self.down
    remove_index(:dictionary_terms,  :name => 'dictionary_attr_idx')
    drop_table :dictionary_terms
  end
end
