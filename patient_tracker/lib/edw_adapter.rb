require 'net/ntlm_http'
require 'net/http'
require 'net/https'
require 'libxml'

# Acts as a middle layer between the EirbServices module and the Eirb Webservice.
# Passes off queries to the eirb and returns queries

class EdwAdapter

  attr_reader :agent
  attr_reader :config

  def initialize(config = ServiceConfig.new)
    @agent = Net::HTTP.new('edwbi.nmff.org', 443)
    @agent.use_ssl = true
    @agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
    @config = config
  end

  # Calls the generated Mechanize agent to perform the search on the remote resource
  # Accepts a param hash of values and converts hash parameters to query string (thanks, Rails!)
  def perform_search(params = {})
    begin
      # # actually NTLM auth, but NTLM Mechanize overwrites the method for ease
      # # see http://www.mindflowsolutions.net/2009/5/21/ruby-ntlm-mechanize
      # agent.basic_auth(config.username, config.password)
      # 
      # xml_response = agent.get(config.url + "&" + params.to_query).content
      
      req = Net::HTTP::Get.new(config.url + "&" + params.to_query, {'connection' => 'keep-alive'})
      req.ntlm_auth(config.username, config.password, true)
      # http.set_debug_output $stderr
      xml_response = @agent.request(req).body
      
      ## TODO Handle errors better here
      LibXML::XML::Error.set_handler do |error|
        puts error.to_s if [LibXML::XML::Error::ERROR, LibXML::XML::Error::FATAL].include? error.level
      end
            
      xml_doc = LibXML::XML::Document.string(xml_response)
      return self.class.format_search_results(xml_doc || "")
    rescue StandardError => bang
      puts "Error pulling data: " + bang
    end
  end
  def self.format_search_results(doc)
    # http://www.vitorrodrigues.com/blog/2007/06/13/ruby-libxml-annoyances/
    nodes = doc.find('//*[local-name()="Detail"]')
    nodes.map do |detail|
      hash = {}
      detail.children.each do |item|
        hash.merge!({item.name.to_sym => item.content})
      end
      hash
    end
  end
end