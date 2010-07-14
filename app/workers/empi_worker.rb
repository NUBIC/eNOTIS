class EmpiWorker
  @queue=:empi
  def self.perform(involvement_id)
    # connect_to_empi
    # Find the involvement and the subject
    # involvement = Involvement.find(involvement_id)
    # begin
    #   study = involvement.study
    #   # if study.read_only?
    #   #   # puts "study #{study.irb_number} is read only, skipping"
    #   #   puts "."
    #   unless study.read_only?
    #     subject     = involvement.subject
    #     puts "#{Time.now} I'd be uploading subject #{subject.id} on study #{study.irb_number} to the EMPI"
    #     # Upload the subject and involvement info to the EMPI
    #     # Empi.put({
    #     #   :gender        => involvement.gender, 
    #     #   :first_name    => subject.first_name,
    #     #   :last_name     => subject.last_name,
    #     #   :date_of_birth => subject.birth_date
    #     # })
    #   end
    # rescue Exception => e
    #   puts "Something went wrong"
    # end
  end
end