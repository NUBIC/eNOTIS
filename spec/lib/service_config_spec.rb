require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../soap_mock_helper')

describe ServiceConfig do

  describe "holds the config options for services" do
    
    before(:each) do 
      s=<<EOS
test:
  url: "http://www.foo.com"
  user: "harry"
  pass: "blah123!"
  store: "eirb"
  number: 123

EOS
      @yml = YAML.parse(s)
      @config = ServiceConfig.new("test",@yml)
    end

    it "get all config options as hash" do
      @config.all.should == {"url" => @yml["test"]["url"].value, 
        "user" => @yml["test"]["user"].value, 
        "pass" => @yml["test"]["pass"].value,
        "store" => @yml["test"]["store"].value,
        "number" => @yml["test"]["number"].value.to_i} # yaml stores all values as strings
    end

    it "accesses keyed values like methods" do
      @config.url.should == @yml["test"]["url"].value
      @config.user.should == @yml["test"]["user"].value
      @config.pass.should == @yml["test"]["pass"].value
      @config.store.should == @yml["test"]["store"].value
      @config.number.should == @yml["test"]["number"].value.to_i # yaml stores all values as strings
    end

    it "still throws 'method_missing' for attrs not in the yaml" do
      lambda { @config.made_up }.should raise_error(NoMethodError)
    end

  end

  describe "works just fine for hash options as it does Yaml options" do
    before(:each) do
      @h = {:blah => {:url => "http://www.bar.com", "num" => 123}}
      @config = ServiceConfig.new("blah",@h)
    end

    it "can access keyed values" do
      @config.url.should == @h[:blah][:url]
      @config.num.should == @h[:blah]["num"].to_i
    end
  end
end
