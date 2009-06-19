class CreateStudyUploads < ActiveRecord::Migration
  def self.up
    create_table :study_uploads do |t|
      t.integer :study_id
      t.integer :user_id
      t.string :upload_file_name
      t.string :upload_content_type
      t.integer :upload_file_size
      t.string :result_file_name
      t.string :result_content_type
      t.integer :result_file_size
      
      t.timestamps
    end
  end

  def self.down
    drop_table :study_uploads
  end
end
