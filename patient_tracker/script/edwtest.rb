require 'rubygems'  
require 'mechanize-ntlm'
# require 'rexml/document'
# include REXML

# sanity checks

agent = WWW::Mechanize.new
agent.basic_auth("nmff-username", "secret")

EDW_PATH = "https://edwbi.nmff.org/ReportServer?%2fReports%2fResearch%2fPSPORE%2fENOTIS+-+TEST"
EDW_QUERY = "https://edwbi.nmff.org/ReportServer?%2fReports%2fResearch%2fPSPORE%2fENOTIS+-+TEST&rs:Command=Render&rs:format=XML&mrd_pt_id=9988101"
begin
  result = agent.get(EDW_PATH).content
  puts "Able to access EDW url\r\n"+result unless result == nil 
rescue
  puts "Not able to access EDW url because:\r\n #{$!}"
end

begin
  result = agent.get(EDW_QUERY).content
  puts "Able to access EDW query\r\n"+result unless result == nil
rescue
  puts "Not able to access EDW query because:\r\n #{$!}"
end
