require 'net/ntlm_http'
require 'net/http'
require 'net/https'
require 'libxml'
require 'uri'

# Adapter layer between the Edw class and the Edw webservice. Passes off queries to the EDW webservice and returns an array of hashes
class EdwAdapter
  attr_accessor :agent
  attr_accessor :config

  def initialize
    self.config = WebserviceConfig.new("/etc/nubic/edw-#{RAILS_ENV.downcase}.yml")
    uri = URI.parse(config[:url])
    self.agent = Net::HTTP.new(uri.host, uri.port)
    if uri.port == 443
      self.agent.use_ssl = true 
      self.agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
    else
      raise "Use SSL for all EDW queries"
    end 
    self.agent.read_timeout = config[:service_timeout].to_i
    self.agent.open_timeout = config[:service_timeout].to_i
  end

  # Accepts a param hash of values and converts hash parameters to query string (thanks, Rails!)
  def perform_search(report_name, params = {})
    begin
      # additional report params 
      params.merge!({"rs:Command" => "Render", "rs:format" => "XML"})
      
      LOG.info("[EdwAdapter] url: #{config[:url]}")
      LOG.info("[EdwAdapter] report: #{report_name}, params: #{params.inspect}")

      req = Net::HTTP::Get.new(config[:url] + "/#{URI.encode(report_name)}" + "&" + params.to_query, {'connection' => 'keep-alive'})
      req.ntlm_auth(config[:username], config[:password], true)
       
      #self.agent.set_debug_output $stderr
      xml_response = agent.request(req).body
      #LOG.debug("#{Time.now} [EdwAdapter] results: #{xml_response.inspect}")

      ## TODO Handle errors better here - yoon
      ## Hush Warning: xmlns: URI ENOTIS_x0020_-_x0020_TEST is not absolute at :1.
      LibXML::XML::Error.set_handler do |error|
        puts error.to_s if [LibXML::XML::Error::ERROR, LibXML::XML::Error::FATAL].include? error.level
      end

      xml_doc = LibXML::XML::Document.string(xml_response)
      return self.class.format_search_results(xml_doc || "")
    rescue TimeoutError, StandardError => bang
      raise WebserviceError.new(bang.message)
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
