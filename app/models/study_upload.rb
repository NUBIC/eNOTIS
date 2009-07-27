class StudyUpload < ActiveRecord::Base

  # Associations
  belongs_to :user
  belongs_to :study

  # Mixins
  has_attached_file :upload
  has_attached_file :result
  
  # Validators  
  validates_attachment_presence :upload # upload must be present on create, result is added later (update) by processor
  validates_attachment_size :upload, :less_than => 5.megabytes # until we have a good reason to change it
  validates_attachment_size :result, :less_than => 5.megabytes
  
  # TODO, try turning these two validations on - yoon
  # validates_attachment_content_type :upload, :content_type => ['text/csv', 'text/plain']
  # validates_attachment_content_type :result, :content_type => ['text/csv', 'text/plain']

end
