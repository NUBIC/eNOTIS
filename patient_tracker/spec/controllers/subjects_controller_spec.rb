require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SubjectsController do

  #Delete this example and add some real ones
  it "should use SubjectsController" do
    controller.should be_an_instance_of(SubjectsController)
  end
  
  describe "importing csv" do
    # post file to create  
    # check file
    # spit it out to csv with errors in another column (check number and names of columns)
    # redirect to x with success
    # process file
    # take me to a processing page

    before(:each) do
      @good_csv = "mrn,first_name,last_name,dob\r\n9988101,,,\r\n9988102,,,\r\n,test10,last10,12/31/04\r\n,test11,last11,6/11/54\r\n,test12,last12,6/12/54\r\n,test13,last13,6/13/55\r\n,test14,last14,7/26/74\r\n,test15,last15,12/31/04\r\n,test16,last16,6/12/54\r\n"
      @bad_csv = "mrn,first_name,last_name,dob\r\n9988101,,,\r\nfoo,,,\r\n,,last10,9/1/45\r\n,test11,last11,6/1/10\r\n,test12,last12,13/31/01\r\n,,,6/13/55\r\n,test14,last14,7/26/74\r\n,test15,last15,12/31/04\r\n,test16,,6/12/54\r\n"
      File.new('good.csv', 'w').syswrite(@good_csv)
      @good_csv_file = File.open('good.csv', 'r')
      File.new('bad.csv', 'w').syswrite(@bad_csv)
      @bad_csv_file = File.open('bad.csv', 'r')
      controller.stub!(:user_must_be_logged_in)
    end
    it "should allow me to post the file to create" do
      controller.stub!(:check_csv).and_return(true)
      post :create, {:file => @good_csv_file}
      response.should be_success
    end
    it "should check the file (success) and redirect to study" do
      controller.should_receive(:check_csv).with(@good_csv_file).and_return(true)
      post :create, {:file => @good_csv_file, :study => 3}
      response.should redirect_to(study_path(:id => 3))
    end
    it "should check the file (failure) and send me back a csv file" do
      controller.should_receive(:check_csv).with(@bad_csv_file).and_return(false)
      post :create, {:file => @bad_csv_file, :study => 3}
      response.headers['Content-Type'].include?("text/csv").should be_true
    end
    it "should check csv for validity" do
      controller.class.check_csv(@good_csv_file).should be_true
      controller.class.check_csv(@bad_csv_file).should be_false
    end
    

    
  end
end
