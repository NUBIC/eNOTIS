require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'mechanize-ntlm'

describe EdwAdapter do

  before(:each) do
    @config = Object.new
    @config.stub!(:url).and_return("http://blah.com?action")
    @config.stub!(:username).and_return("foo")
    @config.stub!(:password).and_return("bar")

    @agent = Object.new
    WWW::Mechanize.stub!(:new).and_return(@agent)
    @agent.stub!(:get)
    @agent.stub!(:basic_auth)

    @adapter = EdwAdapter.new(@config)
  end

  it "calls the adapter with login credentials" do
    @agent.should_receive(:basic_auth).with(@config.username, @config.password)
    @adapter.perform_search({:mrn => "901"})
  end

  it "assembles a query string and gets the url" do
    @agent.should_receive(:get).with("http://blah.com?action&mrn=901")
    @adapter.perform_search({:mrn => "901"})
  end
  
  it "assembles a multi-part query string and gets the url" do
    @agent.should_receive(:get).with("http://blah.com?action&dob=7%2F4%2F50&name=July+Forth")
    @adapter.perform_search({:name => "July Forth", :dob => "7/4/50"})
  end
  
  
  it "can convert returned XML results to a hash" do
    xml = "<?xml version=\"1.0\" encoding=\"utf-8\"?><Report xsi:schemaLocation=\"ENOTIS_x0020_-_x0020_TEST https://edwbi.nmff.org/ReportServer?%2fReports%2fResearch%2feNOTIS%2fENOTIS+-+TEST&amp;rs%3aCommand=Render&amp;rs%3aFormat=XML&amp;rc%3aSchema=True\" Name=\"ENOTIS - TEST\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"ENOTIS_x0020_-_x0020_TEST\"><mrd_pt_idParameter>Mrd Patient Identification: 9988101</mrd_pt_idParameter><MainTable><Detail_Collection><Detail><mrd_pt_id>9988101</mrd_pt_id><first_nm>test1</first_nm><last_nm>last1</last_nm><country_nm>USA</country_nm><address_1>10 E CHICAGO AVE</address_1><zip_code>60601</zip_code><gender_nm>Female</gender_nm><race_nm>African American</race_nm><mrtl_status_nm>Divorced</mrtl_status_nm><fncl_class_nm>BCBS PPO</fncl_class_nm><birth_dts>6/9/1954</birth_dts></Detail></Detail_Collection></MainTable></Report>"
    arr_of_hashes = [{ :mrd_pt_id => "9988101",
      :first_nm => "test1",
      :last_nm => "last1",
      :country_nm => "USA",
      :address_1 => "10 E CHICAGO AVE",
      :zip_code => "60601",
      :gender_nm => "Female",
      :race_nm => "African American",
      :mrtl_status_nm => "Divorced",
      :fncl_class_nm => "BCBS PPO",
      :birth_dts => "6/9/1954"}]

    @agent.should_receive(:get).and_return(xml)
    @adapter.perform_search({:mrd_pt_id => "9988101"}).should == arr_of_hashes
  end
end
