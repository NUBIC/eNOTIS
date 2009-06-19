class StudyUpload < ActiveRecord::Base
  belongs_to :user
  belongs_to :study
  
  has_attached_file :upload
  has_attached_file :result
  
  validates_attachment_presence :upload
  validates_attachment_size :upload, :less_than => 5.megabytes
  validates_attachment_content_type :upload, :content_type => ['text/csv', 'text/plain']
  # validates_attachment_presence :result
  validates_attachment_size :result, :less_than => 5.megabytes
  validates_attachment_content_type :result, :content_type => ['text/csv', 'text/plain']

end
