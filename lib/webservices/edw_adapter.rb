require 'net/ntlm_http'
require 'net/http'
require 'net/https'
require 'libxml'

# Adapter layer between the Edw class and the Edw webservice. Passes off queries to the EDW webservice and returns an array of hashes
class EdwAdapter
  attr_accessor :agent
  attr_accessor :config

  def initialize
    self.config = WebserviceConfig.new("/etc/nubic/edw-#{RAILS_ENV.downcase}.yml")
    self.agent = Net::HTTP.new('edwbi.nmff.org', 443)
    self.agent.use_ssl = true
    self.agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
    self.agent.read_timeout = config[:service_timeout].to_i
    self.agent.open_timeout = config[:service_timeout].to_i
  end

  # Accepts a param hash of values and converts hash parameters to query string (thanks, Rails!)
  def perform_search(params = {})
    begin
      # TODO: figure out a better logger, with levels. - yoon
      LOG.info("[EdwAdapter] report: #{config[:url]}")
      LOG.info("[EdwAdapter] params: #{params}")
      req = Net::HTTP::Get.new(config[:url] + "&" + params.to_query, {'connection' => 'keep-alive'})
      req.ntlm_auth(config[:username], config[:password], true)
      # http.set_debug_output $stderr
      xml_response = agent.request(req).body
      # LOG.debug("#{Time.now} [EdwAdapter] results: #{xml_response.inspect}")

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
