require 'bcsec'
require 'nokogiri'
require 'rack'
require 'rest_client'
module Bcsec
  module Modes
    module Middleware
      module EnotisFront
        class CasLoginTicket
          include Bcsec::Cas::ConfigurationHelper
          def initialize(app)
            @app = app
          end
          def call(env)
            @env = env
            if env['REQUEST_METHOD'] == 'GET' && env['PATH_INFO'] == '/login_ticket'
              html_string = RestClient.get(cas_login_url)
              n = Nokogiri::HTML(html_string)
              lt = (n/"input[name='lt']").first.attributes['value'].to_s
              ::Rack::Response.new([lt], 200, {'Content-Type' => "text/plain"}).finish
            else
              @app.call(env)
            end
            
          end
          def configuration
            @env['bcsec.configuration']
          end
        end
      end
    end
  end
end