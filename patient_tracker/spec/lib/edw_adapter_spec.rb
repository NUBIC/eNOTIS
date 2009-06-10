require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

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
  
  #   it "can convert returned XML results to a hash" do
  #   end
end
