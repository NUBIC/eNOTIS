require 'http-access2'
gem 'soap4r', '>=1.5.8'
require 'soap/wsdlDriver'

module EirbServices

  class Server

     attr_accessor :connection_url, :username, :password, :storename

     def connection(params)
       @connection_url = params[:url]
       @username = params[:username]
       @password = params[:password]
       @storename = params[:storename]
       @login_result = nil
     end

     def authenticate!
       true
     end
     
     def authenticated?
       false
     end

     def perform_search(params)
       []
     end
  end

  class DataServiceError < RuntimeError 
      
  end

end
