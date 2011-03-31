namespace :medserv do

  desc 'email all PIs the service form'
  task :service_email => :environment do
    # Only actually mail in production, fake all other envs

    studies = get_studies

    # Write out the studies we used
    manifest_file("study_manifest"){ |f| studies.each{|s| f << "#{s.irb_number}, #{s.irb_status}, \"#{s.name}\"\n"}}
    
    # Get a list of PI's from this studies list
    puts "Getting our list of PI's"
    pis = get_pi_nets_from_studies(studies)

    # storing the record of the studies
    manifest_file("pi_list"){|f| pis.each{|p| f << "#{p}\n"}}

    # Load PI proxy list we keep near this rake file
    proxies = load_proxy_file 
    
    # Collect netids of people who have proxies
    prox_nets = get_proxy_netids(proxies)

    puts "Removing proxied PIs"
    # Flag the PI's who have email proxys 
    # Remove them from the list
    puts "pi_netids size: #{pis.size}"
    puts "proxied pi netids size: #{prox_nets.size}"
    pis.delete_if{|u| prox_nets.include?(u)}
    puts "proxied removed size: #{pis.size}"
    # It's okay if the numbers don't add up. There might be pi's in the proxy list that are not
    # removed becuase they don't have studies in our study list

    # Iterate over PI list
    # send an email to the PI if no proxy
    sent_list = []
    not_sent_list = []
    pis.each do |netid|
      pi = User.find_by_netid(netid)
      if pi.email.nil? or pi.email.empty?
        puts "#{pi.netid} HAS NO EMAIL!!!!"
        not_sent_list << "#{pi.netid} has no email\n"
      else
        if Rails.env.production?
          Notifier.deliver_pi_service_form(pi.email)
        else
          puts "Would have sent email to #{pi.email} if this was prod"
        end
        sent_list << "Sent to #{pi.email} on #{Time.now}\n"
      end
    end

    manifest_file("list_of_emailed_pi"){|f| sent_list.each{|l| f << l }}
    manifest_file("list_of_missing_email_pi"){|f| not_sent_list.each{|l| f << l }}
    # Done!
  end

  desc 'email reminders for service forms'
  task :service_email_reminder => [:environment, :set_medical_service_flag] do
    #- Identify the studies that are currently active.
    studies = get_studies
    puts "Studies: #{studies.count}"
    #- Remove the studies that have already responded to the survey. Any level of response. We will deal with partial responses separately
    studies.reject!{|s| !s.uses_medical_services.nil?} #rejecting any level of response
    puts "After removing ones responded #{studies.count}"
    all_personnel = []
    studies.each do |s|
      s.roles.each do |r|
        all_personnel << r.netid
      end
    end
    all_personnel.compact!
    all_personnel.uniq!
    puts "emails to go out: #{all_personnel.count}"
    sent_list = []
    convert_to_emails(all_personnel).each do |p|
      if Rails.env.production?
        begin
           Notifier.deliver_pi_service_reminder(p)
        rescue
           puts "Failed to send on email '#{p}'"
        end
      else
        puts "Would have sent email to #{p} if ENV was prod \n"
      end
      sent_list << "Sent to #{p} at #{Time.now}\n"
    end
    # Emailing Warren Warren Kibbe <wakibbe@northwestern.edu>
    # He wanted a copy of the email when it was sent out
    if Rails.env.production?
      Notifier.deliver_pi_service_reminder('wakibbe@northwestern.edu')
    else
      puts "Would have sent email to wakibbe@northwestern.edu if ENV was prod \n"
    end

    manifest_file("list_of_emailed_pi_reminder"){|f| sent_list.each{|l| f << l }}
    puts "Done!"
  end

  desc 'email final reminder for service forms'
  task :service_email_final_reminder => [:environment] do
    studies = get_non_compliant_studies
    pis = studies.map do |s|
      if s.principal_investigator
        s.principal_investigator.netid
      end
    end
    pis.compact!
    pis.uniq!
    pis_and_studies = []
    pis.each do |pi|
      pis_and_studies << {:pi => pi, 
        :studies => studies.select{|s| s.principal_investigator && s.principal_investigator.netid == pi}
      }
      print "."
      STDOUT.flush
    end
    # preparing the email group
    pis_and_studies.each do |ps|
      puts "-----------"
      puts ps[:pi]
      puts ps[:studies].map{|s| "#{s.irb_number} - #{s.irb_status}"
      cc_list = ps[:studies].map do |s| 
        all_roles = s.roles.map(&:netid)
        co_i = s.roles.select{|r| r.project_role == "Co-Investigator"}.map(&:netid)
        all_roles.reject!{|n| co_i.include?(n)} # removing co-investigators
        all_roles.delete(ps[:pi]) # removing the pi
        all_roles 
      end
      cc_list.flatten!
      cc_list.uniq! #multiple roles and multiple studies is possible, removing dupes
      puts cc_list.join(',')
      puts ""
    end
  end

  desc 'generate proxy lookup file'
  task :proxy_lookup => :environment do
    manifest_list = [] 
    # Get studies from our custom list
    studies = get_studies
    # load proxies
    proxies = load_proxy_file
    # for each proxy group
    proxy_lookup_data = [] # collection of PIs and their studies for these proxy peoples

    proxies.each do |proxy|
      puts "Processing PIs and studies for #{proxy["to"]}... #{proxy["user_list"].count} of them"
      study_proxies = {}
      study_proxies[:proxies] = proxy["netids"]
      study_proxies[:studies] = []
      proxy["user_list"].each do |pi_str|
        netid = pi_str.split(", ")[1]
        # grab all their studies
        pi_studies = studies.select{ |s| s.principal_investigator && s.principal_investigator.netid == netid}
        study_proxies[:studies] << pi_studies.map(&:irb_number)
      end
      study_proxies[:studies].flatten!
      proxy_lookup_data << study_proxies 
    end #proxies.each
    File.open(File.join(File.dirname(__FILE__),"../","proxy_study_list.yaml"),"w") do |f|
       f << YAML.dump(proxy_lookup_data) 
    end
  end

  desc 'add proxy email people as OVERSIGHT role in cc_pers'
  task :add_proxy_roles => :environment do
    proxies = load_proxy_file
    proxies.each do |proxy|
      proxy["netids"].each do |netid|
        #look up netid by email
        found = Bcsec.authority.find_user(netid)
        # if found, add this person to cc_pers in designated role
        if found
          UsersToPers.insert_user_into_cc_pers(found.username, {
            :first_name => found.first_name,
            :last_name => found.last_name
          }, "Oversight")
          #puts Pers::Person.find_by_username(found.username)
          #puts Pers::Login.find_by_username_and_portal(found.username, 'eNOTIS')
          #puts Pers::GroupMembership.find_by_username_and_portal_and_group_name(found.username, 'eNOTIS', 'Oversight')
        else
          puts "Could not find #{netid} by netid lookup in bcsec/ldap"
        end
      end
    end
  end

  desc 'set studies uses_medical_services flag to false from a csv list'
  task :set_medical_service_flag => :environment do

    # List provided by Debbie 
    FasterCSV.foreach(File.dirname(__FILE__) + '/studies_that_do_not_use_medical_services.csv', :headers => true) do |row|
      s = Study.find_by_irb_number(row["IRB_number"])
      if s
        s.uses_medical_services = true
        s.save!
        puts "Updated med serv to 'true' on #{s.irb_number}"
      else
        puts "Could not find #{row["IRB_number"]}"
      end
    end

  end

  # HELPER METHODS ##################################################

  def load_proxy_file
    puts "Loading proxy email list"
    # Load PI proxy list
    YAML.load(File.open(File.dirname(__FILE__) + '/proxies.yaml','r'))
  end

  def convert_to_emails(net_arr)
    emails = []
    net_arr.each do |net|
      u = Bcsec.authority.find_user(net.downcase)
      u = User.find_by_netid(net.downcase) if u.nil? || u.email.nil? 
      if u && u.email
        print "."
        STDOUT.flush
        emails << u.email
      else
        puts "\nERROR not finding an email for :#{net}"
      end
    end
    emails
  end

  def get_pi_nets_from_studies(studies)
    pis = [] 
    studies.each do |s|
      pis << s.principal_investigator
    end
    pis.reject!{|p| p.nil?} #not sure why we have nils in there!!!!!
    uniq_pi_nets = pis.map(&:netid).uniq
    return uniq_pi_nets
  end

  def get_proxy_netids(proxies)
    prox_nets = []
    proxies.each do |group|
      group["user_list"].each do |u_str|
        prox_nets << u_str.split(", ")[1]
      end
    end
    prox_nets.uniq! # There might be overlap
  end

  def get_studies
    # Get studies based on our critera
    puts "Getting studies based on our critera"
    studies = Study.find(:all, :conditions => "closed_or_completed_date is null and irb_status not in ('Pre Submission', 'Closed/Terminated', 'Withdrawn', 'Rejected','Exempt Review: Awaiting Correspondence', 'Exempt Approved', 'Exempt Review: Changes Requested', 'In Expedited Review')")
  end

  def get_non_compliant_studies
     #- Identify the studies that are currently active.
    studies = get_studies
    puts "Studies: #{studies.count}"
    #- Remove the studies that have already responded to the survey. Any level of response. We will deal with partial responses separately
    studies.reject!{|s| !s.uses_medical_services.nil?} #rejecting any level of response
    puts "After removing ones responded #{studies.count}"
    studies
  end

  def manifest_file(name, &block)
    ts = Time.now.strftime("%Y%m%d%H%M") 
    file = File.open("log/#{name}-#{ts}.csv",'w') 
    yield file
    file.close
    puts "We wrote #{name}-#{ts}.csv"
  end

end
