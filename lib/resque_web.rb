require 'sinatra/base'
class ResqueWeb < Sinatra::Base
  require 'resque/server'
  
  use Rack::ShowExceptions
  Resque::Server.use Rack::Auth::Basic do |username, password|
    username == 'enotis_jobs'
    password == 'enotis_jobs'
  end

  def call(env)
    if env["PATH_INFO"] =~ /^\/admin\/jobs/
      env["PATH_INFO"].sub!(/^\/admin\/jobs/, '')
      env['SCRIPT_NAME'] = '/admin/jobs'
      app = Resque::Server.new
      app.call(env)
    else
      super
    end
  end
end
