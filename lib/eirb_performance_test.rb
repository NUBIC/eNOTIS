require 'webservices/plugins/eirb_services'

class SpeedTest

  def self.start
    File.open('eirb_speeds.log','a') do |f|
      chunks = [10,25,50,100,500,1000]
      header(f)
      chunks.each do |size|
        begin 
          start = Time.now
          users = EirbServices.chunked_search("eNOTIS Study Basics",nil,size)
          report(f,start,Time.now,size,users.size)
        end
      end
    end
  end
  
  def self.report(io,started,ended,chunk_size,record_count)
    io.write("Test for chunk size #{chunk_size} took #{ended - started} for #{record_count} records \r\n")
  end

  def self.header(io)
      io.write("\r\n======================== Eirb WS Speed test ========================\r\n")
      io.write("Time: #{Time.now}\r\n")
  end
end
