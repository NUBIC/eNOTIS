require 'activemessaging/processor'
class StudyUpload < ActiveRecord::Base
  include AASM
  include ActiveMessaging::MessageSender

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

  aasm_column :state
  aasm_initial_state :new
  aasm_state :new
  aasm_state :published 
  aasm_state :complete
  aasm_state :failed

  aasm_event :publish do 
    transitions :to => :published, :from=>[:new,:failed], :guard=>:queue?
  end

  aasm_event :processed do
    transitions :to => :complete, :from=>[:published]
  end 

  aasm_event :fail do 
    transitions :to => :failed, :from=>[:published]
  end

  def queue?
    begin
      return false unless publish :patient_upload, self.id.to_s
    rescue
      return false
    end
      return true
  end
  
end
