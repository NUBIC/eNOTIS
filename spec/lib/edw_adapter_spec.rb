require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EdwAdapter do

  before(:each) do
    @config = {:username => "user", :password => "secret", :url => "https://blah.com?action"}
    WebserviceConfig.stub!(:new).and_return(@config)
    @agent = Object.new
    Net::HTTP.stub!(:new).and_return(@agent)
    @agent.stub!(:use_ssl=)
    @agent.stub!(:verify_mode=)
    @agent.stub!(:read_timeout=)
    @agent.stub!(:open_timeout=)
    @resp = Object.new()
    @resp.stub!(:body).and_return("<?xml version=\"1.0\" encoding=\"utf-8\"?><Detail><mrd_pt_id>9988101</mrd_pt_id></Detail>")
    @agent.stub!(:request).and_return(@resp)  
    @adapter = EdwAdapter.new
    @req = Object.new 
    Net::HTTP::Get.stub!(:new).and_return(@req)
    @req.stub!(:ntlm_auth)
  end

  it "sets up the request with login credentials" do
    @req.should_receive(:ntlm_auth).with(@config[:username], @config[:password], true)
    @adapter.perform_search("foo",{:mrd_pt_id => "901"})
  end

  it "assembles a request with a query string" do
    Net::HTTP::Get.should_receive(:new).with("https://blah.com?action/foo&mrd_pt_id=901&rs%3ACommand=Render&rs%3Aformat=XML", {'connection' => 'keep-alive'})
    @adapter.perform_search("foo",{:mrd_pt_id => "901"})
  end
  
  it "assembles a request with a multi-part query string" do
    Net::HTTP::Get.should_receive(:new).with("https://blah.com?action/foo&dob=7%2F4%2F50&name=July+Forth&rs%3ACommand=Render&rs%3Aformat=XML", {'connection' => 'keep-alive'})
    @adapter.perform_search("foo",{:name => "July Forth", :dob => "7/4/50"})
  end
  
  it "calls the adapter with the request" do
    @agent.should_receive(:request).with(@req)
    @adapter.perform_search("foo",{:mrd_pt_id => "901"})
  end
  
  it "can convert returned XML results to a hash" do
    xml = "<?xml version=\"1.0\" encoding=\"utf-8\"?><Report xsi:schemaLocation=\"ENOTIS_x0020_-_x0020_TEST https://edwbi.nmff.org/ReportServer?%2fReports%2fResearch%2feNOTIS%2fENOTIS+-+TEST&amp;rs%3aCommand=Render&amp;rs%3aFormat=XML&amp;rc%3aSchema=True\" Name=\"ENOTIS - TEST\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"ENOTIS_x0020_-_x0020_TEST\"><mrd_pt_idParameter>Mrd Subject Identification: 9988101</mrd_pt_idParameter><MainTable><Detail_Collection><Detail><mrd_pt_id>9988101</mrd_pt_id><first_nm>test1</first_nm><last_nm>last1</last_nm><country_nm>USA</country_nm><address_1>10 E CHICAGO AVE</address_1><zip_code>60601</zip_code><gender_nm>Female</gender_nm><race_nm>African American</race_nm><mrtl_status_nm>Divorced</mrtl_status_nm><fncl_class_nm>BCBS PPO</fncl_class_nm><birth_dts>6/9/1954</birth_dts></Detail></Detail_Collection></MainTable></Report>"
    response = Object.new
    response.stub!(:body).and_return(xml)
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

    @agent.should_receive(:request).and_return(response)
    @adapter.perform_search("foo",{:mrd_pt_id => "9988101"}).should == arr_of_hashes
  end
end
