class ENStudyWorker
  @queue = :validator
  def self.perform(irb_number)
    Eirb.connect
    # puts Eirb.find_status({:irb_number=>irb_number})
    
    # puts Eirb.find_basics({:irb_number=>irb_number}).inspect
    puts Study.find_by_irb_number(irb_number).inspect
    
    # [{:expiration_date=>"4/24/2008", :closed_or_completed_date=>"", :irb_number=>"STU00000507", :approved_date=>"4/25/2007", :research_type=>"Social/Behavioral", :irb_status=>"Expired", :accrual_goal=>"300", :title=>"Decision-making under static and dynamic ambiguity", :total_subjects_at_all_ctrs=>"", :name=>"Decision-making", :multi_inst_study=>"", :periodic_review_open=>"false"}]
  end
end
