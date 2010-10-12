require 'uri'
module Bcsec
  module Modes
    class EnotisFront < Bcsec::Modes::Cas
      def self.key
        :enotis_front
      end
      def kind
        :cas
      end
      def on_ui_failure
        ::Rack::Response.new do |resp|
          return_uri = URI.join(service_url, '/login')
          return_uri.query = attempted_path == "/" ? nil : "return=#{escape(attempted_path)}"
          login_uri = URI.parse(cas_login_url)
          login_uri.query = "service=#{escape(return_uri)}&gateway=true"
          resp.redirect(login_uri.to_s)
        
        # ::Rack::Response.new do |resp|
        #   # login_uri = URI.parse(cas_login_url)
        #   # login_uri.query = "service=#{escape(service_url)}"
        #   # resp.redirect(login_uri.to_s)
        #   login_uri = URI.join(request.url, "/login")
        #   login_uri.query = attempted_path.blank? ? nil : "return=#{escape(attempted_path)}"
        #   resp.redirect(login_uri.to_s)
        end
      end
      def on_logout
        ::Rack::Response.new { |resp| resp.redirect('login?logout=true') }

        # return_uri = URI.join(service_url, '/login')
        # logout_uri = URI.parse(cas_logout_url)
        # logout_uri.query = "url=#{escape(return_uri)}"
        # ::Rack::Response.new { |resp| resp.redirect(logout_uri.to_s) }
      end
    end
  end  
end