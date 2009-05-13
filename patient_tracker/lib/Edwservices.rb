require 'rexml/document'
require 'net/http'
include REXML

module ProtocolNode

  def initialize(xm_node="")
 	@xml_node=xml_node
  end

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


module EDWRequests

  
  def get_study_list
    study_list =  []
    base = "http://165.124.223.197:3000/protocols/study_list"
    http_response = Net::HTTP.get_response(URI.parse(base))
    xml_response = REXML::Document.new(http_response.body);

    xml_response.elements.each("protocols/protocol") do  |protocol|
    	return Protocol.new(xml_node=protocol)
    end
  end


  def find_by_coordinator(net_id)
    study_list =  []
    base = "http://165.124.223.197:3000/coordinators/study_access_list?net_id=" 
    http_response = Net::HTTP.get_response(URI.parse(base+net_id))
    xml_response = REXML::Document.new(http_response.body);

    xml_response.elements.each("protocols/protocol") do  |protocol|
    	study_list << Protocol.new(xml_node=protocol) 
    end
    return study_list
  end


end	



