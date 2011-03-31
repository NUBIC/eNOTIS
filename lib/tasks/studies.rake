namespace :studies do

  desc 'clean up all studies that should not be in the system'
  task :delete_dead_ones do
    # How they get in the system you ask?
    # Well, we filter studies in the eirb study import list based on their irb_status
    # if a study changes from an excepted status to one that is filtered 
    # this study drops off the map (so to speak). 
    # We will never update it again from eirb but it will sit in our system
    # in it's last known state.
    to_remove = [
       "Withdrawn", 
       "Rejected", 
       "Exempt Review: Changes Requested",
      "Original Version", 
      "Exempt Review: Changes Requested",
      "Exempt Approved", 
      "Pre Submission"]

    studies = Study.find(:all, :conditions => "irb_status in (#{to_remove.map{|r| "'#{r}'"}.join(',')})")
    studies.each do |s|
      irb_num = s.irb_number
      irb_stat = s.irb_status
      if s.involvements.count == 0
        Study.delete(s.id)
        puts "Deleted #{irb_num} - #{irb_stat}"
      else
        puts "Cannot delete #{irb_num} it has participants on the study!"
      end
    end
  end

end
