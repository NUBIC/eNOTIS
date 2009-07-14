require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ClinicalData do
  before(:each) do
 
  end

  it "holds a key and a value" do
    cd = ClinicalData.create(:key => "abc", :value => "hello123")
    cd.key.should eql("abc")
    cd.value.should eql("hello123")
  end

  it "holds a key, a value, and a date" do
    t = Time.now
    cd = ClinicalData.create(:key => "frg", :value => "123hello+!", :occured_at => t)
    cd.key.should eql("abc")
    cd.value.should eql("hello123")
    cd.occured_at.should eql(t)
  end

end
