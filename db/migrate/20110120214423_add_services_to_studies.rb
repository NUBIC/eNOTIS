class AddServicesToStudies < ActiveRecord::Migration
  def self.up
    add_column :studies, :uses_medical_services, :boolean
  end

  def self.down
    remove_column :studies, :uses_medical_services
  end
end
