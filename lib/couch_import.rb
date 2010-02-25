require 'CouchRest'


#using the couch as the study source instead of eirb
class CouchImport
  
  

  def self.do
    @db =CouchRest.database('http://127.0.0.1:5984/eirb_prod') 
     
    studies = @db.view('eirb/studies')["rows"]
    studies.each do |s_hash|
        s = s_hash["value"]
        puts s["irb_number"]
        study = Study.find(:first, :conditions => ["irb_number =?",s["irb_number"]]) || Study.new
        study.irb_number = s["irb_number"]
        study.irb_status = s["irb_status"]
        study.name = s["name"]
        study.title = s["title"]
        study.approved_date = s["approved_date"]
        study.closed_or_completed_date = s["closed_or_completed_date"]
        study.expiration_date = s["expiration_date"]
        study.research_type = s["research_type"]
       
        study.save!
    end
  end


end

