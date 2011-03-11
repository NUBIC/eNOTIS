require 'webservices'

namespace :importer do

 # TODO: add update to bcsec enotis roles!!!!

  desc "Does our full (weekender) update process - Don't wait up for this one! It likes to party all night"
  task :full_mutha_trucking_update => [:environment, :all_studies, :update_managed_studies] do
    puts "Full updating..."
  end

  desc "Does our priority update process, active studies and studies with managed participants - Takes about 2-3 hours to run"
  task :priority_update => [:environment, :active_studies] do
    puts "Priority updating..."
  end

  desc "Queries the eirb for a full list of studies and imports all these studies"
  task :all_studies => :environment do
    puts "Querying eIRB, it's slow, give us a minute..."
    irb_numbers = Eirb.find_study_export.map{|i| i[:irb_number]}.uniq
    puts "Importing ALL studies" 
    import_studies(irb_numbers)
  end

  desc "Updates study data for studies active in eNOTIS (will not query the eIRB for a study list so no new studies are added with this task)"
  task :active_studies => :environment do
    puts "Querying eNOTIS DB for active studies..."
    irb_numbers = Involvement.find(:all, :include => :study).map{|i| i.study.irb_number}.uniq
    puts "Importing active studies (managed by eNOTIS or managed externall)"
    import_studies(irb_numbers)
  end

  desc "Queries the known subject/participant external sources and flags the appropriate eNOTIS study with the source which has subject/participants"
  task :update_managed_studies => :environment do
    source_list = ['NOTIS', 'ANES'] #and soon Registar! The source name needs to match how it's written in the webservices/edw.rb file. See the stored searches hash.
    source_list.each do |source|
      query = "find_#{source}_study_list".to_sym # building the query name we're gonna call based on our naming convention in edw.rb
      study_list = Webservices::Edw.send(query)
      irb_numbers = study_list.map{|i| i[:irb_number]} # just need the irb_numbers 
      set_managed_studies(irb_numbers, source)
    end
  end

  # ------ end of tasks - helper methods below --------
  
  # Gets as study, sets it to being managed by a source
  def set_managed_studies(irb_numbers, source)
    irb_numbers.each do |irb_num|
      study = Study.find_by_irb_number(irb_num)
      if study
        study.managed_by(source)
        study.save!
      else
        raise "Study not found"
      end
    end
  end

  # This looks long but most of it is printing stuff to STDOUT or calculating 
  # import time for those running the rake command manually.
  def import_studies(irb_numbers)
    t= Time.now
    puts "Starting at #{t}"
    tr = []
    puts "#{irb_numbers.count} studies to import"
    puts "This might take a while (~#{(irb_numbers.count*10)/60} minutes), you should probably take a walk or find a nice book to read" if irb_numbers.count > 500
    STDOUT.flush
    irb_numbers.each do |irb_num|
      # Import the data for the study
      study = Study.find_by_irb_number(irb_num)
      if study.nil?
        print "#{irb_num} not found, creating it"
        study = Study.create(:irb_number => irb_num)
      end
      t1 = Time.now
      print " Importing #{irb_num}"
      Webservices::Importer.import_external_study_data(study)
      t2 = Time.now
      tr << (t2-t1)
      print " in #{t2-t1} seconds"
      study.reload
      print " with errors" if study.import_errors?
      print "\n"
      STDOUT.flush       
    end
    tn = Time.now
    total = ((tn-t)/60)
    mean = tr.inject{ |sum, el| sum + el }.to_f / tr.size
    puts "Ending at #{tn} - Import time:#{total} minutes"
    puts "Mean: #{mean}"
  end

end
