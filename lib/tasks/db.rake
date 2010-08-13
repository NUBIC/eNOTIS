# http://www.postgresql.org/docs/8.3/static/app-pgdump.html
require 'erb'
require 'yaml'

namespace :db do
  desc "setup"
  task :br_setup => :environment do
    # Shorter abbreviations work for me
    HWIA = HashWithIndifferentAccess
    # Pull the instance username and password out of ActiveRecord
    config = HWIA.new(ActiveRecord::Base.connection.instance_variable_get("@config"))
    raise 'This only works for postgres' unless config[:adapter] == "postgresql"
    host           = config[:host] || 'localhost'
    port           = config[:port] || 5432
    username       = config[:username]
    database       = config[:database]
    @password      = config[:password]
    @options       = "-U #{username} -h #{host} -p #{port} #{database}"
    @backup_config = HWIA.new(YAML::load(ERB.new(IO.read(File.join(Rails.root,"config","db_backup.yml"))).result))
    @backup_folder = @backup_config[:backup_folder][Rails.env.to_sym]
    @app_name      = @backup_config[:app_name]
  end
  
  desc "backup database"
  task :backup => :br_setup do
    timestamp     = Time.now.strftime("%Y%m%d%H%M%S")
    # If the hostname isn't provided, then use localhost    
    # ditto for postgresql's default port
    compressed_file = "#{@app_name}_#{Rails.env}-#{timestamp}.sql.gz"
    destination     = File.join(@backup_folder, compressed_file)
    puts "Compressed File = #{compressed_file}"
    # Unlike mysqldump, you cant enter in the password on the command line
    # you can set an environment variable, so this shouldnt be a problem    
    
    ENV['PGPASSWORD'] = @password
    # Check for directory permissions
    `mkdir -p #{File.expand_path(@backup_folder)}`
    `pg_dump -o #{@options} | gzip -f --best > #{destination}`
    ENV['PGPASSWORD'] = nil
  end
  
  desc "restore database. You need to use quotes - rake 'db:restore[20100813161954]'"
  task :restore, :timestamp, :needs => :br_setup do |t, args| 
    timestamp = args[:timestamp]
    raise 'You need to provide a timestamp' unless timestamp
    puts "You may need to have the db superuser do this command"
    puts "You need to drop and recreate the database, and make sure the owner is properly assigned"
    compressed_file = "#{@app_name}_#{Rails.env}-#{timestamp}.sql.gz"
    destination     = File.join(@backup_folder, compressed_file)
    
    # Check for file existence
    ENV['PGPASSWORD'] = @password
    `cat #{@backup_folder}/#{@app_name}_#{Rails.env}-#{timestamp}.sql.gz | gunzip | psql #{@options}`
    ENV['PGPASSWORD'] = nil
  end
end