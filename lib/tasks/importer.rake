require 'webservices'

namespace :importer do

 # TODO: add update to bcsec enotis roles!!!!

  desc "Queries the eirb for a full list of studies and imports all these studies"
  task :full_update => :environment do
    puts "Querying eIRB, it's slow, give us a minute..."
    irb_numbers = Eirb.find_study_export.map{|i| i[:irb_number]}.uniq
    import_study_list(irb_numbers)
    # Query externals and flag study as 'externally managed'
    # Get all externall managed studies, flag with source
    # Query these against the sources system, use the source key
    # to drive the query interface.
  end

  desc "Queries the DB for a list of active studies and updates data for those"
  task :priority_update => :environment do
    puts "Querying eNOTIS DB for active studies..."
    irb_numbers = Involvement.find(:all, :include => :study).map{|i| i.study.irb_number}.uniq
    import_study_list(irb_numbers)
  end

  def import_study_list(irb_numbers)
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
