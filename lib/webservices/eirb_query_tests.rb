require 'eirb_adapter'
require 'eirb_translations'
require 'service_logger'
#require 'lib/webservices/plugins/eirb_adapter'

class EirbQueryTests

  def self.test
    params = {:startRow => 825, 
              :numRows => 5,
              :expandMultiValueCells => true,
              :savedSearchName => "eNOTIS Study Subject Populations",
              :parameters => nil}

    runs = []
    yml = ERB.new(File.read(File.join(RAILS_ROOT,"config/eirb_services.yml"))).result
    config = ServiceConfig.new(RAILS_ENV, YAML.parse(yml))
    eirb_adapter = EirbAdapter.new(config)

    tests=10
    tests.times do |x|
      runs[x] = eirb_adapter.perform_search(params) 
    end

    puts "Run sizes: #{runs.map{|x| x.length}.join(',')}"
    max = 0
    runs.each do |i| 
      if i.length > max
        max = i.length
      end
    end
    puts "max: #{max}"
    max.times do |k|
      print "#{k+1}:".center(5)
      tests.times do |j|
        runs_hash = runs[j][k]
        if runs_hash
        print " #{runs_hash["ID"]}(#{j+1})".center(16) 
        else
          16.times{ print " " }
        end
      end
      puts " - "
    end
   
  end
  
end
