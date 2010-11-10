require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Subject do
  before(:each) do
  end

  it "should create a new instance given valid attributes" do
    Factory(:subject).should be_valid
  end
  
  it "should handle two digit years in dates" do
    Subject.new("birth_date"=>"12/18/34").birth_date.should == Date.parse("1934-12-18")
    Subject.new("birth_date"=>"12/18/07").birth_date.should == Date.parse("2007-12-18")
  end
  
    
  # Eliminating this method for now, in favor of simplifying - we just create for now, will do a find/create in the future with the EMPI - yoon
  
  # describe "finding and creating" do
  #   before(:each) do
  #     @found_subject = Factory(:subject)
  #     @created_subject = Factory(:subject)
  #     @params = {:subject => {}}
  #   end
  #   
  #   it "should find a subject, by params" do
  #     Subject.should_receive(:find).and_return(@found_subject)
  #     @params[:subject] = {:nmff_mrn => "90210", :first_name => "Pikop N", :last_name => "Dropov", :birth_date => "1934-02-12"}
  #     Subject.find_or_create(@params).should == @found_subject    
  #   end
  # 
  #   it "should NOT find a subject by one param" do
  #     s = {:nmff_mrn => "90210", :first_name => "Pikop N", :last_name => "Dropov", :birth_date => "1934-02-12"}   
  #     q = {:nmff_mrn => "90211", :first_name => "Pikop N", :last_name => "Milton", :birth_date => "1934-02-12"}   
  #     Subject.create(q)
  #     Subject.create(s)
  #     @params[:subject] = {:first_name => "Pikop N"}
  #     Subject.find_or_create(@params).nmff_mrn.should be_nil
  #   end
  # 
  #   it "should create a subject if it isn't found" do
  #     Subject.should_receive(:create).and_return(@created_subject)
  #     @params[:subject] = {:first_name => "Pikop N", :last_name => "Dropov", :birth_date => "1934-02-12"}
  #     Subject.find_or_create(@params).should == @created_subject
  #   end
  #   
  #   it "should return nil if not found or created" do
  #     Subject.should_receive(:find).and_return(nil)
  #     Subject.should_receive(:create).and_return(nil)
  #     @params[:subject] = {:nmff_mrn => "90210", :first_name => "Pikop N", :last_name => "Dropov", :birth_date => "1934-02-12"}
  #     Subject.find_or_create(@params).should == nil
  #   end
  # end
  
end
