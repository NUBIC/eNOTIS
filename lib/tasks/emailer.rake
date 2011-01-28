namespace :emailer do

  desc 'email all PIs the service form'
  task :service_email => :environment do
    # Only actually mail in production, fake all other envs
    ts = Time.now.strftime("%Y%m%d%H%M") 

    # Get studies based on our critera
    puts "Getting studies based on our critera"
    studies = Study.find(:all, :conditions => "irb_status not in ('Closed/Terminated', 'Rejected','Exempt Review: Awaiting Correspondence', 'Exempt Approved', 'Exempt Review: Changes Requested', 'In Expedited Review')");0
    studies = studies.reject{|s| !s.closed_or_completed_date.nil? };0
    
    # Write out the studies we used
    File.open("study_manifest-#{ts}.csv",'w'){ |f| studies.each{|s| f << "#{s.irb_number}, #{s.irb_status}, \"#{s.name}\"\n"}}
    # Get a list of PI's from this list
    puts "Getting our list of PI's"
    pis = []
    studies.each do |s|
      pis << s.principal_investigator
    end
    
    puts "Uniq-afying our PI list"
    pis.reject!{|p| p.nil?} #not sure why we have nils in there!!!!!
    uniq_pi_nets = pis.map(&:netid).uniq
    File.open("pi_list-#{ts}.csv",'w'){|f| uniq_pi_nets.each{|p| f << "#{p}\n"}}

    puts "Loading proxy email list"
    # Load PI proxy list
    proxies = YAML.load(File.open(File.dirname(__FILE__) + '/proxies.yaml','r'))
    
    # Collect netids of people who have proxies
    prox_nets = []
    proxies.each do |group|
      group["user_list"].each do |u_str|
        prox_nets << u_str.split(", ")[1]
      end
    end
    
    prox_nets.uniq! # There might be overlap

    puts "Removing proxied PIs"
    # Flag the PI's who have email proxys 
    # Remove them from the list
    puts "uniq_pi_nets size: #{uniq_pi_nets.size}"
    puts "proxied pi nets size: #{prox_nets.size}"
    uniq_pi_nets.delete_if{|u| prox_nets.include?(u)}
    puts "proxied removed size: #{uniq_pi_nets.size}"

    # Iterate over PI list
    # send an email to the PI if no proxy
    sent_list = []
    not_sent_list = []
    uniq_pi_nets.each do |netid|
      pi = User.find_by_netid(netid)
      if pi.email.nil? or pi.email.empty?
        puts "#{pi.netid} HAS NO EMAIL!!!!"
        not_sent_list << "#{pi.netid} has no email"
      else
        if Rails.env.production?
          Notifier.deliver_pi_service_form(pi.email)
        else
          puts "Would have sent email to #{pi.email} if this was prod"
        end
        sent_list << "Sent to #{pi.email} on #{Time.now}"
      end
    end

    File.open("list_of_emailed_pi-#{ts}.txt","w"){|f| sent_list.each{|l| f << l }}
    File.open("list_of_missing_email_pi-#{ts}.txt","w"){|f| not_sent_list.each{|l| f << l }}
    # If proxy then
    # Open/create proxy_email file
    # Write PI's name to email
    # Write out link to each of their studies
    # Done!
  end

end
