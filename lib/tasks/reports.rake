namespace :reports do
  # grab the files generated with something like this:
  # scp wakibbe@enotis.nubic.northwestern.edu:/var/www/apps/enotis/releases/20111011194510/tmp/users_2011-12-06.csv .
  # scp wakibbe@enotis.nubic.northwestern.edu:/var/www/apps/enotis/releases/20111011194510/tmp/studies_2011-12-06.csv .
  # scp wakibbe@enotis.nubic.northwestern.edu:/var/www/apps/enotis/releases/20111011194510/tmp/study_roles_2011-12-06.csv .
  # scp wakibbe@enotis.nubic.northwestern.edu:/var/www/apps/enotis/releases/20111219163530/tmp/accrual_2011-12-20.csv .
  # scp wakibbe@enotis.nubic.northwestern.edu:/var/www/apps/enotis/releases/20111219163530/tmp/usage_2011-12-20.csv .
  
  desc "Dump users to file"
  task :users => :environment do      
    cols = User.content_columns.map(&:name)
    file_name = RAILS_ROOT + "/tmp/users_#{Time.now.strftime("%Y-%m-%d")}.csv"
    puts "Writing file to " + file_name
    FasterCSV.open(file_name, "w") do |csv|
      csv << ["sort_name", "full_name", "user_id"] + cols
      User.all.each do |s|
        STDOUT.flush
        csv << [s.last_name+", "+s.first_name, [s.first_name, s.middle_name, s.last_name].join(" "), s.id] + cols.map{|c| s[c]}
      end
      puts "done"
    end
  end

  desc "Dump studies to file"
  task :studies => :environment do      
    cols = Study.content_columns.map(&:name)
    file_name = RAILS_ROOT + "/tmp/studies_#{Time.now.strftime("%Y-%m-%d")}.csv"
    puts "Writing file to " + file_name
    FasterCSV.open(file_name, "w") do |csv|
      csv << ["study_id"] + cols
      Study.all.each do |s|
        STDOUT.flush
        csv << [s.id] + cols.map{|c| s[c]}
      end
      puts "done"
    end
  end


  desc "Dump study_roles to file"
  task :study_roles => :environment do      
    cols = Role.content_columns.map(&:name)
    # not sure why, but not all the columns come over
    cols = ["study_id", "user_id", "project_role", "consent_role", "created_at", "updated_at", "netid"]
    file_name = RAILS_ROOT + "/tmp/study_roles_#{Time.now.strftime("%Y-%m-%d")}.csv"
    puts "Writing file to " + file_name
    FasterCSV.open(file_name, "w") do |csv|
      csv << cols
      Role.all.each do |s|
        STDOUT.flush
        csv << cols.map{|c| s[c]}
      end
      puts "done"
    end
  end
  
  desc "Analyze data entry per month"
  task :enotis_monthly => :environment do
    entries = Involvement.count(:conditions=>["created_at between :start and :end", {:start=>4.months.ago, :end=>3.months.ago}])

    currency = Involvement.all(:select=>"created_at", :conditions=>["created_at between :start and :end", {:start=>4.months.ago, :end=>3.months.ago}])

    studies = Involvement.send(:with_exclusive_scope) { Involvement.all( :select=>"count(distinct study_id) as cnt", :conditions=>["created_at between :start and :end", {:start=>6.months.ago, :end=>5.months.ago}] ) }[0].cnt
    studies = Involvement.send(:with_exclusive_scope) { Involvement.all( :select=>"count(distinct study_id) as cnt", :conditions=>["created_at between :start and :end", {:start=>5.months.ago, :end=>4.months.ago}] ) }[0].cnt
    studies = Involvement.send(:with_exclusive_scope) { Involvement.all( :select=>"count(distinct study_id) as cnt", :conditions=>["created_at between :start and :end", {:start=>4.months.ago, :end=>3.months.ago}] ) }[0].cnt
    studies = Involvement.send(:with_exclusive_scope) { Involvement.all( :select=>"count(distinct study_id) as cnt", :conditions=>["created_at between :start and :end", {:start=>3.months.ago, :end=>2.months.ago}] ) }[0].cnt
    studies = Involvement.send(:with_exclusive_scope) { Involvement.all( :select=>"count(distinct study_id) as cnt", :conditions=>["created_at between :start and :end", {:start=>2.months.ago, :end=>1.months.ago}] ) }[0].cnt
    studies = Involvement.send(:with_exclusive_scope) { Involvement.all( :select=>"count(distinct study_id) as cnt", :conditions=>["created_at between :start and :end", {:start=>1.months.ago, :end=>Date.today}] ) }[0].cnt
  end

  desc "generate eNOTIS accrual report"
  task :enotis_monthly_accrual => :environment do
    studies = Study.has_medical_services
    now = Date.today
    month_range=(1..13)
    
    cols = ["study_id", "irb_number", "irb_status", "name", "title", "accrual_goal"]
    file_name = RAILS_ROOT + "/tmp/accrual_#{Time.now.strftime("%Y-%m-%d")}.csv"
    puts "Writing file to " + file_name
    FasterCSV.open(file_name, "w") do |csv|
      csv <<  cols + ["approved_date","current_accrual"] + month_range.map{|i| now.advance(:months => -i).to_date}
      studies.each do |study|
        accrual_array = [((study.approved_date.blank?) ? nil : study.approved_date.to_date)]
        accrual_array << [study.accrual]
        month_range.each do |month_index|
          start_date = now.advance(:months => -month_index) +1 
          end_date = now.advance(:months => 1-month_index)
          accrual_array << study.accrual_during_period(start_date,end_date)
        end

        STDOUT.flush
        csv << cols.map{|c| study[c]} + accrual_array
      end
      puts "done"
    end
  end

  desc "generate eNOTIS usage report"
  task :enotis_monthly_usage => :environment do
    studies = Study.has_medical_services
    now = Date.today
    month_range=(1..13)
    
    cols = ["study_id", "irb_number", "irb_status", "name", "title", "accrual_goal"]
    file_name = RAILS_ROOT + "/tmp/usage_#{Time.now.strftime("%Y-%m-%d")}.csv"
    puts "Writing file to " + file_name
    FasterCSV.open(file_name, "w") do |csv|
      csv <<  cols + ["approved_date","current_accrual"] + month_range.map{|i| now.advance(:months => -i).to_date}
      studies.each do |study|
        accrual_array = [((study.approved_date.blank?) ? nil : study.approved_date.to_date)]
        accrual_array << [study.accrual]
        month_range.each do |month_index|
          start_date = now.advance(:months => -month_index) +1
          end_date = now.advance(:months => 1-month_index)
          accrual_array << study.entries_during_period(start_date,end_date)
        end

        STDOUT.flush
        csv << cols.map{|c| study[c]} + accrual_array
      end
      puts "done"
    end
  end
end
