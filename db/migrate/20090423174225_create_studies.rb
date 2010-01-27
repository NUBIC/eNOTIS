class CreateStudies < ActiveRecord::Migration
  def self.up
    create_table :studies do |t|
      t.string :irb_number
      t.timestamps
    end

    add_index(:studies, :irb_number, :unique => true, :name => 'studies_irb_number_idx')
  end

  def self.down
    remove_index(:studies, :name => 'studies_irb_number_idx')
    drop_table :studies
  end
end
