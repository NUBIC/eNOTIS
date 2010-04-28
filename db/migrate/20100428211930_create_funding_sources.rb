class CreateFundingSources < ActiveRecord::Migration
  def self.up
    create_table :funding_sources do |t|
      t.integer :study_id
      t.string :name
      t.string :code
      t.string :category
      t.timestamps
    end
  end

  def self.down
    drop_table :funding_sources
  end
end
