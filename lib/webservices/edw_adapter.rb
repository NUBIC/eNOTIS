require 'net/ntlm_http'
require 'net/http'
require 'net/https'
require 'libxml'
require 'service_logger'

# Acts as a middle layer between the EdwServices module and the Edw Webservice.
# Passes off queries to the edw and returns queries
class EdwAdapter

  attr_reader :agent
  attr_reader :config

  def initialize(config = ServiceConfig.new)
    @config = config
    @agent = Net::HTTP.new('edwbi.nmff.org', 443)
    @agent.use_ssl = true
    @agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
    @agent.read_timeout = config.service_timeout.to_i
    @agent.open_timeout = config.service_timeout.to_i
  end

  # Accepts a param hash of values and converts hash parameters to query string (thanks, Rails!)
  def perform_search(params = {},debug=false)
    begin
      report_url = config.url
      # TODO: figure out a better logger, with levels. - yoon
      WSLOGGER.info("#{Time.now} [EdwAdapter] report: #{report_url}")
      WSLOGGER.info("#{Time.now} [EdwAdapter] params: #{params}")
      req = Net::HTTP::Get.new(report_url + "&" + params.to_query, {'connection' => 'keep-alive'})
      req.ntlm_auth(config.username, config.password, true)
      # http.set_debug_output $stderr
      xml_response = @agent.request(req).body
      # WSLOGGER.debug("#{Time.now} [EdwAdapter] results: #{xml_response.inspect}")

      ## TODO Handle errors better here - yoon
      ## Hush Warning: xmlns: URI ENOTIS_x0020_-_x0020_TEST is not absolute at :1.
      LibXML::XML::Error.set_handler do |error|
        puts error.to_s if [LibXML::XML::Error::ERROR, LibXML::XML::Error::FATAL].include? error.level
      end

      xml_doc = LibXML::XML::Document.string(xml_response)
      return self.class.format_search_results(xml_doc || "")
    rescue TimeoutError,StandardError => bang
      raise DataServiceError.new(bang.message)
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
