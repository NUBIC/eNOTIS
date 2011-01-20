class AddServicesToStudies < ActiveRecord::Migration
  def self.up
    add_column :studies, :uses_medical_services, :boolean
    add_column :studies, :medical_services_update_at, :datetime
  end

  def self.down
    remove_column :studies, :uses_medical_services
    remove_column :studies, :medical_services_update_at
  end
end
