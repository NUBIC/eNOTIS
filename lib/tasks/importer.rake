require 'webservices'

namespace :importer do

 # TODO: add update to bcsec enotis roles!!!!

  desc "Does our full (weekender) update process - Don't wait up for this one! It likes to party all night"
  task :full_mutha_trucking_update => [:environment, :all_studies, :update_managed_studies, "users:update_cc_pers"]

  desc "Does our priority update process, active studies and studies with managed participants. Then it updates cc_pers with new users - Takes about 2-3 hours to run"
  task :priority_update => [:environment, :active_studies, "users:update_cc_pers"]

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
    irb_numbers = Involvement.find(:all, :include => :study).map{|i| i.study.irb_number}
    irb_numbers.concat(Study.find(:all, :conditions => "managing_system is not null").map(&:irb_number))
    irb_numbers.uniq!
    puts "Importing active studies (managed by eNOTIS or managed externaly by some other system)"
    import_studies(irb_numbers)
  end

  desc "Queries the known subject/participant external sources and flags the appropriate eNOTIS study with the source which has subject/participants"
  task :update_managed_studies => :environment do
    source_list = ['NOTIS', 'REGISTAR', 'ANES'] #and soon ANES! When they get their data straightend out 
    source_list.each do |source|
      query = "find_#{source}_study_list".to_sym # building the query name we're gonna call based on our naming convention in edw.rb
      study_list = Edw.send(query)
      irb_numbers = study_list.map{|i| i[:irb_number]} # just need the irb_numbers 
      set_managed_studies(irb_numbers, source)
    end
  end

  desc "Retries all studies that have import errors"
  task :retry_studies_with_errors => :environment do
    puts "Querying the db for any studies that have import errors"
    studies = Study.find(:all, :conditions => {:import_errors => true})
    puts "retrying #{studies.count} studies"
    import_studies(studies.map(&:irb_number))
  end

  # ------ end of tasks - helper methods below --------
  
  # Gets as study, sets it to being managed by a source
  def set_managed_studies(irb_numbers, source)
    irb_numbers.each do |irb_num|
      study = Study.find_by_irb_number(irb_num)
      if study
        if study.is_managed?
          puts "Found: #{irb_num} - already managed by: #{study.managing_system}"
        else
          if study.involvements.empty?
            study.managed_by(source)
            study.save!
            puts "Found: #{irb_num} - Now managed by :#{source}"
          else
            puts "Participants exist on study #{irb_num}!!! setting it to managed by #{enotis} will clobber data on the next import. You'll have to set this mannually if that's what you really want to do"
          end
        end
      else
        puts "!!! Study not found: #{irb_num}"
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
    puts "This might take a while (~#{(irb_numbers.count*17)/60} minutes), you should probably take a walk or find a nice book to read" if irb_numbers.count > 500
    puts "Note: studies with '(*)' are managed externally so import includes subjects and involvements"
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
      print "(*)" if study.is_managed?
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
