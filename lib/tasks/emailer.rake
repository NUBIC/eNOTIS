namespace :emailer do

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

  desc 'email proxy people the serivce form'
  task :proxy_email => :environment do
    manifest_list = [] 
    # Get studies from our custom list
    studies = get_studies
    # load proxies
    proxies = load_proxy_file
    # for each proxy group
    proxies.each do |proxy|
      puts "Processing PIs and studies for #{proxy["to"]}... #{proxy["user_list"].count} of them"
      email_data = {} # collection of PIs and their studies for these proxy peoples
      proxy["user_list"].each do |pi_str|
        netid = pi_str.split(", ")[1]
        # grab all their studies
        pi_studies = studies.select{ |s| s.principal_investigator && s.principal_investigator.netid == netid}
        # build email data
        email_data[netid] = {
          :name => pi_str,
          :studies => pi_studies.map(&:irb_number)
        }
      end

      # send email
      if Rails.env.production?
        Notifier.deliver_proxy_service_form(proxy["to"],email_data)
      elsif Rails.env.staging?
        Notifier.deliver_proxy_service_form("b-chamberlain@northwestern.edu",email_data)
      else
        puts "Would have sent email to #{proxy["to"]} if this was prod"
      end
      puts "Recording results..."
      #recording the results
      manifest_list << {:to => proxy["to"], :payload => email_data}
    end #proxies.each

    # report sending and copy of email body sent in manifest 
    manifest_file("proxy_processing_results"){|f| f << YAML::dump(manifest_list)}
  end

  # HELPER METHODS ##################################################

  def load_proxy_file
    puts "Loading proxy email list"
    # Load PI proxy list
    YAML.load(File.open(File.dirname(__FILE__) + '/proxies.yaml','r'))
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
    studies = Study.find(:all, :conditions => "irb_status not in ('Closed/Terminated', 'Rejected','Exempt Review: Awaiting Correspondence', 'Exempt Approved', 'Exempt Review: Changes Requested', 'In Expedited Review')")
    studies.reject{|s| !s.closed_or_completed_date.nil? }
  end

  def manifest_file(name, &block)
    ts = Time.now.strftime("%Y%m%d%H%M") 
    file = File.open("log/#{name}-#{ts}.csv",'w') 
    yield file
    file.close
    puts "We wrote #{name}-#{ts}.csv"
  end

end
