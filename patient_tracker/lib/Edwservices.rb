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

  def irb_number
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
  
  def get_study_list
    study_list =  []
    base = "http://209.252.134.167:3000/protocols/study_list"
    http_response = Net::HTTP.get_response(URI.parse(base))
    xml_response = REXML::Document.new(http_response.body);

    xml_response.elements.each("protocols/protocol") do  |protocol|	
      study = Protocol.new
      study.xml_node = protocol
      study_list.push(study)
    end
    study_list
  end

  def find_by_study_id(study_id)
    study_list=[]
    base = "http://209.252.134.167:3000/protocols/find_by_studyid?studyid="
    http_response = Net::HTTP.get_response(URI.parse(base+study_id))
    xml_response = REXML::Document.new(http_response.body);

    xml_response.elements.each("protocol") do  |protocol|	
      study = Protocol.new
      study.xml_node = protocol
      study_list.push(study)
    end
    study_list
        
  end


  def find_by_coordinator(net_id)
    study_list =  []
    base = "http://209.252.134.167:3000/coordinators/study_access_list?net_id=" 
    http_response = Net::HTTP.get_response(URI.parse(base+net_id))
    xml_response = REXML::Document.new(http_response.body);

    xml_response.elements.each("protocols/protocol") do  |protocol|
        study = Protocol.new
        study.xml_node = protocol
    	study_list << study
    end
    return study_list
  end


end	

module PatientRequests
  def find_by_mrn(mrn)
    patient_list =  []
    base = "http://209.252.134.167:3000/patients/master_patient_lookup?mrn=" 
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

