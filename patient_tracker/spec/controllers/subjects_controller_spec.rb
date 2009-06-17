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
      @good_random_cols_csv = "dob,last_name,mrn,first_name\r\n,,9988101,\r\n,,9988102,\r\n12/31/04,last10,,test10\r\n6/11/54,last11,,test11\r\n6/12/54,last12,,test12\r\n6/13/55,last13,,test13\r\n7/26/74,last14,,test14\r\n12/31/04,last15,,test15\r\n6/12/54,last16,,test16\r\n"
      @bad_random_cols_csv = "dob,mrn,last_name,first_name\r\n1/1/01,9988101,,\r\n1/3/23,foo,,\r\n9/1/45,,last10,\r\n6/1/10,,last11,test11\r\n13/31/01,,last12,test12\r\n6/13/55,,,\r\n7/26/74,,last14,test14\r\n12/31/04,,last15,test15\r\n6/12/54,,,test16\r\n"
      File.new('good.csv', 'w').syswrite(@good_csv)
      File.new('bad.csv', 'w').syswrite(@bad_csv)
      File.new('good_random_cols.csv', 'w').syswrite(@good_random_cols_csv)
      File.new('bad_random_cols.csv', 'w').syswrite(@bad_random_cols_csv)
      @good_csv_file = File.open('good.csv', 'r')
      @bad_csv_file = File.open('bad.csv', 'r')
      @good_random_cols_file = File.open('good_random_cols.csv', 'r')
      @bad_random_cols_csv_file = File.open('bad_random_cols.csv', 'r')
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
    it "should check csv for mrn or (first_name, last_name, dob)" do
      controller.class.check_csv(@good_csv_file).should be_true
      controller.class.check_csv(@bad_csv_file).should be_false
    end
    it "should check csv for for mrn or (first_name, last_name, dob) with columns in random order" do
      controller.class.check_csv(@good_random_cols_file).should be_true
      controller.class.check_csv(@bad_random_cols_csv_file).should be_false
    end
    

    
  end
end
