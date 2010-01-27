require 'rubygems'
require 'couchrest'
require 'webservices/plugins/eirb_services'

class CouchStudy

  CDATA = {:pis => "pi",:co_pis => "co_pis",:coords => "coords", :al => "access_list",:pops => "populations", :acrl => "subject_accrual"}
  PROC_ORDER = [:pis,:co_pis,:coords,:al,:pops,:acrl]

  attr_accessor :db, :studies

  def initialize(db_name)
    @db = CouchRest.database!(db_name)
    @studies = []
  end

  def get_studies
    @studies = EirbServices.find_basics #find all the studies
  end

  def get_pis(id)
    EirbServices.find_principal_investigators(:irb_number => id)
  end

  def get_co_pis(id)
    EirbServices.find_co_investigators(:irb_number => id)
  end

  def get_coords(id)
    EirbServices.find_coordinators(:irb_number => id)
  end

  def get_al(id)
    EirbServices.find_access_list(:irb_number => id)
  end

  def get_pops(id)
    EirbServices.find_populations(:irb_number => id)
  end

  def get_acrl(id)
    EirbServices.find_accrual(:irb_number => id)
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
    puts "Done creating the studies"
    @studies.each do |study|
      PROC_ORDER.each do |k|
        puts "Processing '#{k}' for study #{study[:irb_number]}"
        begin
        data = send("get_#{k}",study[:irb_number])
        rescue
        data = [{:irb_number => study[:irb_number],:error => "query to eirb failed"}]
        end
        data.each do |d|
          append(CDATA[k],d)
        end
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
