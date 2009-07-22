class StudyUpload < ActiveRecord::Base

  # Associations
  belongs_to :user
  belongs_to :study

  # Mixins
  has_attached_file :upload
  has_attached_file :result
  
  # Validators  
  # TODO Why are these validators turned off? -blc 
  validates_attachment_presence :upload
  validates_attachment_size :upload, :less_than => 5.megabytes
  # validates_attachment_content_type :upload, :content_type => ['text/csv', 'text/plain']

  # Results will not be available on upload create, they are added later
  # validates_attachment_presence :result
  validates_attachment_size :result, :less_than => 5.megabytes
  # validates_attachment_content_type :result, :content_type => ['text/csv', 'text/plain']

end
