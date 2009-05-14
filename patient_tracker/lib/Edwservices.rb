require 'rexml/document'
require 'net/http'
include REXML

module ProtocolNode
  attr_accessor :xml_node

  def name
    @xml_node.elements["name"].text
  end

  def description
    @xml_node.elements["description"].text
  end

  def study_id
    @xml_node.elements["irb_number"].text
  end

end

module PatientNode
  attr_accessor :xml_node

  def first_name
    @xml_node.elements["first_name"].text
  end

  def last_name
    @xml_node.elements["last_name"].text
  end

  def mrn
    @xml_node.elements["mrn"].text
  end
  
  def date_of_birth
    @xml_node.elements["dob"].text
  end

  def description
    @xml_node.elements["description"].text
  end

end

module ProtocolRequests
  URL_BASE = "http://localhost:3000"

  def get_study_list
    study_list =  []
    xml_response = get_payload("#{URL_BASE}/protocols/study_list")
    xml_response.elements.each("protocols/protocol") do  |protocol|	
      study = Protocol.new
      study.xml_node = protocol
      study_list.push(study)
    end
    study_list
  end

  def find_by_study_id(study_id)
    study_list=[]
    xml_response = get_payload("#{URL_BASE}/protocols/find_by_studyid?studyid=#{study_id}")
    if xml_response
      xml_response.elements.each("protocol") do  |protocol|	
        study = Protocol.new
        study.xml_node = protocol
        return study
      end
      return nil
    end
        
  end


  def find_by_coordinator(net_id)
    study_list =  []
    xml_response = get_payload("#{URL_BASE}/coordinators/study_access_list?netid=#{net_id}")
    if xml_response 
      xml_response.elements.each("protocols/protocol") do  |protocol|
          study = Protocol.new
          study.xml_node = protocol
    	  study_list << study
      end
    end
    return study_list
  end

  def find_all_coordinator_netids(limit =nil)
    coordinators = []
    xml_response = get_payload("#{URL_BASE}/coordinators/all_netids#{limit ? '?limit='+limit.to_s : nil }")
    if xml_response
      xml_response.elements.each("coordinators/coordinator") do |coord|
        coordinators << coord.elements["netid"].text
      end
    end
    coordinators
  end

  def get_payload(url)
    begin
      http_response = Net::HTTP.get_response(URI.parse(url))
      REXML::Document.new(http_response.body);
    rescue StandardError => bang
      puts "Error pulling data: " + bang
    end
  end

end	

module PatientRequests
  def find_by_mrn(mrn)
    patient_list =  []
    base = "#{URL_BASE}/patients/master_patient_lookup?mrn=" 
    http_response = Net::HTTP.get_response(URI.parse(base+mrn))
    xml_response = REXML::Document.new(http_response.body);

    xml_response.elements.each("patient") do  |node|
        patient = Patient.new
        patient.xml_node = node
    	patient_list << patient
    end
    return patient_list
  end

end

