class NonEditablePatientsFeature < ActiveRecord::Migration
  def self.up
    add_column(:studies, :read_only, :boolean)
    add_column(:studies, :read_only_msg, :string)
  end

  def self.down
    remove_column(:studies, :read_only)
    remove_column(:studies, :read_only_msg)
  end
end
