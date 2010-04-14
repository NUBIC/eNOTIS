require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TwoDigitYear do
  it "should compensate for two digit years in the future" do
    TwoDigitYear.compensate_for_two_digit_year("1/2/34").should == Date.parse("1/2/1934")
  end
  it "should compensate for two digit years in the past" do
    TwoDigitYear.compensate_for_two_digit_year("1/2/08").should == Date.parse("1/2/2008")
  end
  it "should allow you to set the cutoff date" do
    TwoDigitYear.compensate_for_two_digit_year("1/2/34", 34).should == Date.parse("1/2/2034")
    TwoDigitYear.compensate_for_two_digit_year("1/2/08", 7).should == Date.parse("1/2/1908")
  end
  it "should handle nils" do
    TwoDigitYear.compensate_for_two_digit_year(nil).should be_nil
  end
end
