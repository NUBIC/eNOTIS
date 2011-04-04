namespace :studies do

  desc 'clean up all studies that should not be in the system'
  task :delete_dead_ones => :environment do
    dead_studies.each do |s|
      irb_num = s.irb_number
      irb_stat = s.irb_status
      if s.involvements.count == 0
        Study.destroy(s.id)
        puts "Deleted #{irb_num} - #{irb_stat}"
      else
        puts "Cannot delete #{irb_num} it has participants on the study!"
      end
    end
  end

  desc 'print out a list of all the bad netids we have in study roles'
  task :print_bad_netids => :environment do
    puts "Finding bad netids in eIRB data..."
    live_studies.each do |s|
      s.roles.each do |r|
        user = Bcsec.authority.find_user(r.netid)
        unless user
          puts "#{s.irb_number}, \"#{s.irb_status}\", #{r.netid}, \"#{(r.project_role.length > 50) ? "#{r.project_role[0..50]}..." : r.project_role }\"" 
        end
      end
    end
    puts "Done"
  end

  # How they get in the system you ask?
  # Well, we filter studies in the eirb study import list based on their irb_status
  # if a study changes from an excepted status to one that is filtered 
  # this study drops off the map (so to speak). 
  # We will never update it again from eirb but it will sit in our system
  # in it's last known state.
  STATUS_TO_REMOVE = [
    "Withdrawn", 
    "Rejected", 
    "Exempt Review: Changes Requested",
    "Original Version", 
    "Exempt Review: Changes Requested",
    "Exempt Approved", 
    "Pre Submission"]

    def dead_studies
      Study.find(:all, :conditions => "irb_status in (#{STATUS_TO_REMOVE.map{|r| "'#{r}'"}.join(',')})")
    end

    def live_studies
      Study.find(:all, :conditions => "irb_status not in (#{STATUS_TO_REMOVE.map{|r| "'#{r}'"}.join(',')})")
    end

end
