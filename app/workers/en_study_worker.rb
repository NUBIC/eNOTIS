class ENStudyWorker
  @queue = :validator
  def self.perform(irb_number)
    # check for the study's existence
    study = Study.find_by_irb_number(irb_number)
    if study
      puts "the study exists!"
      # # check for coordinators
      # Resque.enqueue(ENCoordinatorChecker, irb_number, study.id)
      # # check for principal_investigators
      # Resque.enqueue(ENPrincipalInvestigatorChecker, irb_number, study.id)
      # # check for co_investigators
      # Resque.enqueue(ENCoInvestigatorChecker, irb_number, study.id)
    else
      # create the study
      # Resque.enqueue(ENStudyCreator, irb_number)
      eirb_study = Eirb.find_basics({:irb_number=>irb_number})[0]
      params = {
        :irb_number               => eirb_study[:irb_number],
        :name                     => eirb_study[:name],
        :title                    => eirb_study[:title],
        :expiration_date          => Chronic.parse(eirb_study[:expiration_date]),
        :irb_status               => eirb_study[:irb_status],
        :approved_date            => Chronic.parse(eirb_study[:approved_date]),
        :research_type            => eirb_study[:research_type],
        :closed_or_completed_date => eirb_study[:closed_or_completed_date]
      }
      Study.create(params)
    end
  end
end
