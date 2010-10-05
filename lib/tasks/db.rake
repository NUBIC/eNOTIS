# http://www.postgresql.org/docs/8.3/static/app-pgdump.html
require 'erb'
require 'yaml'
require 'faker'

namespace :db do
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
    pgpassword_wrapper(@password) do
      # Check for directory permissions
      `mkdir -p #{File.expand_path(@backup_folder)}`
      `pg_dump -O -o -c -x -i #{@options} | gzip -f --best > #{destination}`
    end
  end
  
  desc "restore database. You may need to use quotes on zsh- rake 'db:restore[staging,20100813161954]'"
  task :restore, :env, :timestamp, :needs => :br_setup do |t, args|
    env = args[:env]
    timestamp = args[:timestamp]
    raise 'You need to provide a timestamp' unless timestamp
    raise 'you need to provide an environment' unless env
    compressed_file = "#{@app_name}_#{env}-#{timestamp}.sql.gz"
    destination     = File.join(@backup_folder, compressed_file)
    pgpassword_wrapper(@password) do
      # Check for file existence
      `cat #{@backup_folder}/#{@app_name}_#{env}-#{timestamp}.sql.gz | gunzip | psql #{@options}`
    end
  end

  desc "de-identify current database"
  task :de_id => :environment do 
    raise "I cannot in good conscience let you do this in production" if Rails.env.production?
    Subject.all.each do |subject|
      de_id_subject(subject)
    end
  end
  
  private
  def pgpassword_wrapper(password)
    raise 'You need to pass in a block' unless block_given?
    ENV['PGPASSWORD'] = password
    yield
    ENV['PGPASSWORD'] = nil
  end

  def de_id_subject(subject)
    subject.first_name = Faker::Name.first_name unless subject.first_name.blank?
    subject.middle_name = Faker::Name.first_name unless subject.middle_name.blank?
    subject.last_name = Faker::Name.last_name unless subject.last_name.blank?
    subject.birth_date =(rand(60.years).ago - 18.years).to_date unless subject.birth_date.blank?
    subject.death_date = rand(5.years).ago.to_date unless subject.birth_date.blank?
    subject.address_line1  =Faker::Address.street_address unless subject.address_line1.blank?
    subject.address_line2 =Faker::Address.secondary_address unless subject.address_line2.blank?
    subject.address_line3=Faker::Address.secondary_address unless subject.address_line3.blank?
    subject.phone_number = Faker::PhoneNumber.phone_number.split(" x")[0] unless subject.phone_number.blank?
    subject.email = Faker::Internet.email  unless subject.email.blank?
    subject.save
  end
end
