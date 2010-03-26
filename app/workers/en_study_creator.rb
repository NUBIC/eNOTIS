class ENStudyCreator
  @queue = :study_creator
  
  # Create the study from information fetched from the EIRB
  def self.perform(irb_number)
    puts "I'f this were written, i'd be fetching information from the eirb about study #{irb_number}"
    # Eirb.connect
    # Eirb.find_basics({:irb_number=>irb_number})
  end
end
