class ExternalSystemFieldsAndCleanup < ActiveRecord::Migration
  def self.up
    add_column(:studies, :managing_system, :string)
    remove_column(:subjects, :source_system) # not used
    remove_column(:subjects, :pre_sync_data) #not used
    rename_column(:subjects, :synced_at, :imported_at) #better name
    rename_column(:subjects, :data_source, :import_source) #updating name
    remove_column(:studies, :multi_inst_study) #not being used
    remove_column(:subjects, :no_contact) # same
    remove_column(:subjects, :no_contact_reason) #same
    change_column(:subjects, :external_patient_id, :string)
  end

  def self.down
    remove_column(:studies, :managing_system)
  end
end
