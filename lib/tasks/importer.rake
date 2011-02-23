require 'webservices'

namespace :importer do

  desc "Queries the eirb for a full list of studies and imports all these studies"
  task :full_update => :environment do
    t= Time.now
    puts "Starting at #{t}"
    tr = []
    # Get list of studies from eIRB
    Eirb.connect
    puts "Connected, now getting the full list of studies from eIRB"
    irb_numbers = Eirb.find_study_export
    #irb_numbers = [{:irb_number => "STU00019833"}]
    puts "#{irb_numbers.count} studies to import"
    puts "This might take a while, you should probably take a walk or find a nice book to read" if irb_numbers.count > 500
    irb_numbers.each do |number|
      # Iterate over this list
      irb_num = number[:irb_number]
      # Import the data for the study
      study = Study.find_by_irb_number(irb_num)
      if study.nil?
        print "#{irb_num} not found, creating it"
        study = Study.create(:irb_number => irb_number)
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
