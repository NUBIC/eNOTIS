require 'rubygems'
require 'couchrest'
require 'webservices/plugins/eirb_services'

class CouchStudy

  CHILD_DATA = {:pis => "pi",:co_pis => "co_pis",:coords => "coords", :al => "access_list",:pops => "populations", :acrl => "subject_accrual"}

  attr_accessor :db, :studies

  def initialize(db_name)
    @db = CouchRest.database!(db_name)
    @studies = []
  end

  def get_studies
    @studies = Eirb.find_basics #finds (almost) all the studies
  end

  def get_pis
    Eirb.find_principal_investigators
  end

  def get_co_pis
    Eirb.find_co_investigators
  end

  def get_coords
    Eirb.find_coordinators
  end

  def get_al
    Eirb.find_access_list
  end

  def get_pops
    Eirb.find_populations
  end

  def get_acrl
    Eirb.find_accrual
  end

  def create_studies
    get_studies
    form_couch_id
    @db.bulk_save(@studies)
  end

  # This does all the work
  def process
    puts "Creating the studies"
    create_studies
    CHILD_DATA.each do |k,v|
      puts "Processing '#{v}' for studies"
      #preping the instance var
      data = send("get_#{k}")
      data.each do |d|
        append(v,d)
      end
    end
  end

  def append(key,obj)
    #look in the obj for the irb_number
    begin
      doc = @db.get(obj[:irb_number]) #find the doc
    rescue
      puts "#{obj[:irb_number]} missing from basic query"
      doc = rescue_save(obj)
    end
    if doc[key] && doc[key].is_a?(Array)
      doc[key] << obj
    else
      doc[key]=[obj]
    end
    doc.save
  end

  # Called if parent not found (forces second call and create)
  def rescue_save(obj)
    doc = Eirb.find_basics(:irb_number => obj[:irb_number])
    puts "#{obj[:irb_number]} referenced but not found" if doc.empty?
    d = doc.first
    hmap!(d)
    @db.save_doc(d)
    @db.get(obj[:irb_number])
  end

  def form_couch_id
    @studies.map{|x| hmap!(x)}
  end

  def hmap!(hsh)
    hsh["_id"]=hsh[:irb_number] if hsh[:irb_number]
  end

end
