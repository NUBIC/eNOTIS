class CreateServiceProcedures < ActiveRecord::Migration
  def self.up
    	create_table :service_procedures do |t|
    	  t.integer :service_form_id
        t.integer :service_item_id
        t.string  :location
        t.string  :bill_to
      end
    end
    def self.down
      drop_table :service_procedures
    end
end
