class CreateServiceProcedures < ActiveRecord::Migration
  def self.up
    	create_table :service_procedures do |t|
    	  t.integer :service_report_id
        t.string  :name
        t.integer :times
        t.string  :location
        t.string  :bill_to
      end
    end
    def self.down
      drop_table :service_procedures
    end
end
