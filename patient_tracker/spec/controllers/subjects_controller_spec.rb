require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SubjectsController do

  #Delete this example and add some real ones
  it "should use SubjectsController" do
    controller.should be_an_instance_of(SubjectsController)
  end
  
  describe "importing csv" do
    # post file to create  
    # check file
    # spit it out to csv with errors
    # redirect to x with success
    # process file
    # take me to a processing page

    before(:each) do
      good_csv = "mrn,first_name,last_name,dob\r\n9988101,,,\r\n9988102,,,\r\n,test10,last10,12/31/04\r\n,test11,last11,6/11/54\r\n,test12,last12,6/12/54\r\n,test13,last13,6/13/55\r\n,test14,last14,7/26/74\r\n,test15,last15,12/31/04\r\n,test16,last16,6/12/54\r\n"
      File.new('good.csv', 'w').syswrite(good_csv)
      @good_csv_file = File.open('good.csv')
      controller.stub!(:user_must_be_logged_in)
    end
    it "should allow me to post the file to create" do
      post :create, {:file => @good_csv_file}
      response.should be_success
    end
  end
end
