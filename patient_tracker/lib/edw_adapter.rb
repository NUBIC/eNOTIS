gem 'mechanize-ntlm'

# Acts as a middle layer between the EirbServices module and the Eirb Webservice.
# Passes off queries to the eirb and returns queries

class EdwAdapter

  attr_reader :agent
  attr_reader :config

  def initialize(config = ServiceConfig.new)
    @agent = WWW::Mechanize.new
    @config = config
  end

  # Calls the generated Mechanize agent to perform the search on the remote resource
  # Accepts a param hash of values and converts hash parameters to query string (thanks, Rails!)
  def perform_search(params = {})
    begin
      # actually NTLM auth, but NTLM Mechanize overwrites the method for ease
      # see http://www.mindflowsolutions.net/2009/5/21/ruby-ntlm-mechanize
      agent.basic_auth(config.username, config.password)

      xml_response = agent.get(config.url + "&" + params.to_query)
      xml_doc = REXML::Document.new(xml_response)
      return self.class.format_search_results(xml_doc)
    rescue StandardError => bang
      puts "Error pulling data: " + bang
    end
  end
  def self.format_search_results(results)
    results
  end
end
