require 'CouchRest'


#using the couch as the study source instead of eirb
class CouchImport
  
  

  def self.do
    @db =CouchRest.database('http://127.0.0.1:5984/eirb_complete') 
     
    studies = @db.view('eirb/studies')["rows"]
    studies.each do |s_hash|
        s = s_hash["value"]
       puts s["irb_number"]
        study = Study.find(:first, :conditions => ["irb_number =?",s["irb_number"]]) || Study.new
        study.irb_number = s["irb_number"]
        study.name = s["name"]
        study.title = s["title"]
        study.description = " " #s[:desription]
        study.accrual_goal = s["accrual_goal"]
        study.research_type = s["research_type"]
        study.multi_inst_study = s["multi_inst_study"]
        study.irb_status = s["irb_status"]
        study.approved_date = s["approved_date"]
        study.expiration_date = s["expiration_date"]
        study.periodic_review_open = s["periodic_review_open"]
        p = s["pi"].first
        study.pi_netid = p["pi_netid"]
        study.pi_first_name = p["pi_first_name"]
        study.pi_last_name = p["pi_last_name"]
        study.pi_email = p["pi_email"]
        c = s["coords"].first
        study.sc_netid = c["sc_netid"]
        study.sc_first_name = c["sc_first_name"]
        study.sc_last_name = c["sc_last_name"]
        study.sc_email = c["sc_email"]

        study.save!
    end
  end


end

