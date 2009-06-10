require 'edw_adapter'

module EdwServices

  attr_accessor :edw_adapter
  
  # initializing the EDW connection
  def connect
    yml = File.open(File.join(RAILS_ROOT,"config/edw_services.yml"))
    config = ServiceConfig.new(RAILS_ENV, YAML.parse(yml))
    edw_adapter = EdwAdapter.new(config)
  end

  # Protocol mode
  def get_study_list
  end

  def find_by_study_id(study_id)
  end

  def find_by_coordinator_net_id(net_id)
  end

  def find_all_coordinator_netids(limit=nil)
  end
  
  # Patient mode
  def find_by_mrn(mrn)
    connect
    edw_adapter.perform_search({:mrn => mrn})
  end
  
  def find_by_name_and_dob(name, dob)
    connect
    edw_adapter.perform_search({:name => name, :dob => dob})
  end
end

# 
# require 'rexml/document'
# require 'mechanize-ntlm'
# # require 'net/http'
# include REXML
#  
# module ProtocolNode
#   attr_accessor :xml_node
#  
#   def name
#     if @xml_node.nil?
#       return super
#     end
#     @xml_node.elements["name"].text
#   end
#   
#   def short_title
#     if @xml_node.nil?
#       return super
#     end
#     @xml_node.elements["short_title"].text
#   end
#  
#   def description
#     if xml_node.nil?
#       return super
#     end
#     @xml_node.elements["description"].text
#   end
#  
#   def short_description
#     if @xml_node.nil?
#       return super
#     end
#     @xml_node.elements["short_description"].text
#   end
#  
#   def phase
#     @xml_node.elements["phase"].text
#   end
#  
#   def study_id
#     @xml_node.elements["irb_number"].text
#   end
#  
# end
#  
# module PatientNode
#   attr_accessor :xml_node
#  
#   def first_name
#     if @xml_node.nil?
#       return super
#     end
#     @xml_node.elements["first_name"].text
#   end
#  
#   def last_name
#     if @xml_node.nil?
#       return super
#     end
#     @xml_node.elements["last_name"].text
#   end
#  
#   def mrn
#     if @xml_node.nil?
#       return super
#     end
#     @xml_node.elements["mrn"].text
#   end
#   
#   def date_of_birth
#     if @xml_node.nil?
#       return super
#     end
#     @xml_node.elements["dob"].text
#   end
#  
#   def description
#     if @xml_node.nil?
#       return super
#     end
#     @xml_node.elements["description"].text
#   end
#  
# end
#  
# module ProtocolRequests
#   URL_BASE = "https://edwbi.nmff.org/ReportServer"
#  
#   def get_study_list
#     study_list = []
#     xml_response = get_payload("#{URL_BASE}/protocols/study_list")
#     xml_response.elements.each("protocols/protocol") do |protocol|  
#       study = Protocol.new
#       study.xml_node = protocol
#       study_list.push(study)
#     end
#     study_list
#   end
#  
#   def find_by_study_id(study_id)
#     study_list=[]
#     xml_response = get_payload("#{URL_BASE}/protocols/find_by_studyid?studyid=#{study_id}")
#     if xml_response
#       xml_response.elements.each("protocol") do |protocol|  
#         study = Protocol.new
#         study.xml_node = protocol
#         return study
#       end
#       return nil
#     end
#         
#   end
#  
#  
#   def find_by_coordinator(net_id)
#     study_list = []
#     xml_response = get_payload("#{URL_BASE}/coordinators/study_access_list?netid=#{net_id}")
#     if xml_response
#       xml_response.elements.each("protocols/protocol") do |protocol|
#           study = Protocol.new
#           study.xml_node = protocol
#        study_list << study
#       end
#     end
#     return study_list
#   end
#  
#   def find_all_coordinator_netids(limit =nil)
#     coordinators = []
#     xml_response = get_payload("#{URL_BASE}/coordinators/all_netids#{limit ? '?limit='+limit.to_s : nil }")
#     if xml_response
#       xml_response.elements.each("coordinators/coordinator") do |coord|
#         coordinators << coord.elements["netid"].text
#       end
#     end
#     coordinators
#   end
#  
#   def get_payload(url)
#     begin
#       http_response = Net::HTTP.get_response(URI.parse(url))
#       REXML::Document.new(http_response.body);
#     rescue StandardError => bang
#       puts "Error pulling data: " + bang
#     end
#   end
#  
# end  
#  
# module PatientRequests
#   URL_BASE = "https://edwbi.nmff.org/ReportServer"
# 
#   #https://edwbi.nmff.org/ReportServer?%2fReports%2fResearch%2fPSPORE%2fENOTIS+-+TEST&rs:Command=Render&rs:format=XML&first_nm="test1"
# 
#   def find_by_mrn(mrn)
#     agent = WWW::Mechanize.new
#     agent.basic_auth("","")
#     
#     patient_list = []
#     base = "#{URL_BASE}?%2fReports%2fResearch%2fPSPORE%2fENOTIS+-+TEST&rs:Command=Render&rs:format=XML&mrd_pt_id="
#     http_response = agent.get(base+mrn)
#     xml_response = REXML::Document.new(http_response.body);
#  
#     xml_response.elements.each("patient") do |node|
#         patient = Patient.new
#         patient.xml_node = node
#       patient_list << patient
#     end
#     return patient_list
#   end
#  
# end
#  
#  