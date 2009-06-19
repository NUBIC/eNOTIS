require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SubjectsController do
  describe "importing csv" do
    before(:each) do
      @good_csv = "mrn,first_name,last_name,dob,subject_event_type,subject_event_date\r\n9988101,,,,consented,3/4/09\r\n9988102,,,,consented,3/5/09\r\n,test10,last10,12/31/04,consented,3/6/09\r\n,test11,last11,6/11/54,consented,3/7/09\r\n,test12,last12,6/12/54,consented,3/8/09\r\n,test13,last13,6/13/55,consented,3/9/09\r\n,test14,last14,7/26/74,consented,3/10/09\r\n,test15,last15,12/31/04,consented,3/11/09\r\n,test16,last16,6/12/54,consented,3/12/09\r\n"
      @bad_csv = "mrn,first_name,last_name,dob,subject_event_type,subject_event_date\r\nfoo,,,,consented,3/4/09\r\n9988101,,,,consented,3/4/09\r\n9988102,,,,,3/4/09\r\n9988103,,,,consented,\r\n,test0,last10,9/1/45,consented,3/6/09\r\n,test11,last11,,consented,3/7/09\r\n,test12,,13/31/01,consented,3/8/09\r\n,,last13,6/13/55,consented,3/9/09\r\n,test14,last14,7/26/74,,3/10/09\r\n,test15,last15,12/31/04,consented,\r\n,test16,,6/12/54,,3/12/09\r\n"
      @good_random_cols_csv = "dob,last_name,mrn,first_name,subject_event_type,subject_event_date\r\n,,9988101,,consented,3/4/09\r\n,,9988102,,consented,3/5/09\r\n12/31/04,last10,,test10,consented,3/6/09\r\n6/11/54,last11,,test11,consented,3/7/09\r\n6/12/54,last12,,test12,consented,3/8/09\r\n6/13/55,last13,,test13,consented,3/9/09\r\n7/26/74,last14,,test14,consented,3/10/09\r\n12/31/04,last15,,test15,consented,3/11/09\r\n6/12/54,last16,,test16,consented,3/12/09\r\n"
      @bad_random_cols_csv = "dob,mrn,last_name,first_name,subject_event_type,subject_event_date\r\n1/1/01,9988101,,,,3/4/09\r\n1/3/23,foo,,,consented,3/5/09\r\n9/1/45,,last10,,,3/6/09\r\n6/1/10,,last11,test11,consented,\r\n13/31/01,,last12,test12,consented,3/8/09\r\n6/13/55,,,,,3/9/09\r\n7/26/74,,last14,test14,consented,3/10/09\r\n12/31/04,,last15,test15,consented,3/11/09\r\n6/12/54,,,test16,,\r\n"
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
      controller.class.stub!(:csv_sanity_check).and_return(true)
      controller.class.stub!(:queue_import)
      post :create, {:file => @good_csv_file}
      response.should redirect_to(studies_path)
    end
    it "should create a new StudyUpload with the file attached" do
      controller.class.stub!(:csv_sanity_check).and_return(true)
      controller.class.stub!(:queue_import)
      StudyUpload.should_receive(:create).with({:upload => @good_csv_file, :study_id => "3"}).and_return(Factory(:study_upload, :upload_file_name => "/foo"))
      post :create, {:file => @good_csv_file, :study => 3}
    end
    
    it "should sanity check csv file for mrn or (first_name, last_name, dob), and (subject_event_type, subject_event_date)" do
      controller.class.csv_sanity_check(@good_csv_file.path).should be_true
      controller.class.csv_sanity_check(@bad_csv_file.path).class.should == Array
    end
    it "should sanity check csv file for mrn or (first_name, last_name, dob), and (subject_event_type, subject_event_date) with columns in random order" do
      controller.class.csv_sanity_check(@good_random_cols_file.path).should be_true
      controller.class.csv_sanity_check(@bad_random_cols_csv_file.path).class.should == Array
    end
    it "should sanity check csv file (success) and queue up the file and redirect to study" do
      # controller.class.should_receive(:csv_sanity_check).with(@good_csv_file).and_return(true)
      controller.class.stub!(:csv_sanity_check).and_return(true)
      
      controller.class.should_receive(:queue_import).and_return(true)
      post :create, {:file => @good_csv_file, :study => 3}
      response.should redirect_to(study_path(:id => 3))
    end
    it "should sanity check csv file (success) and queue up the file and redirect to studies path" do
      # controller.class.should_receive(:csv_sanity_check).with(@good_csv_file).and_return(true)
      controller.class.stub!(:csv_sanity_check).and_return(true)
      
      controller.class.should_receive(:queue_import).and_return(true)
      post :create, {:file => @good_csv_file}
      response.should redirect_to(studies_path)
    end
    it "should sanity check csv file (failure) and send me back a csv file" do
      # controller.class.should_receive(:csv_sanity_check).with(@bad_csv_file).and_return([['import_errors', 'mrn'], ["", "foo"]])
      controller.class.stub!(:csv_sanity_check).and_return([['import_errors', 'mrn'], ["", "foo"]])
      
      post :create, {:file => @bad_csv_file, :study => 3}
      response.headers['Content-Type'].should match(/text\/csv/)
      response.headers['Content-Disposition'].should match(/attachment; filename='.*\.csv'/)
    end
    it "should sanity check csv file (failure) and send me back a csv file for IE" do
      # http://www.calicowebdev.com/blog/show/21
      # controller.class.should_receive(:csv_sanity_check).with(@bad_csv_file).and_return([['import_errors', 'mrn'], ["", "foo"]])
      controller.class.stub!(:csv_sanity_check).and_return([['import_errors', 'mrn'], ["", "foo"]])


      request.env['HTTP_USER_AGENT'] = "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)"
      post :create, {:file => @bad_csv_file, :study => 3}
      response.headers['Content-Disposition'].should match(/attachment; filename='.*\.csv'/)
      response.headers['Pragma'].should == 'public'
      response.headers['Content-type'].should match(/text\/plain/)
      response.headers['Cache-Control'].should == 'no-cache, must-revalidate, post-check=0, pre-check=0'
      response.headers['Expires'].should == '0'
    end
    it "should sanity check csv file (failure) and send me back a csv file with a 'import errors' as first header, and a valid column of input errors" do

      post :create, {:file => @bad_csv_file}
      response.body.should match(/^import_errors.*\n.*\n.*\nA subject event type and date is required..*\nA subject event type and date is required..*\n.*\n"A first_name and last_name and dob, or an mrn is required. .*\n"A first_name and last_name and dob, or an mrn is required. .*\n"A first_name and last_name and dob, or an mrn is required. .*\nA subject event type and date is required..*\nA subject event type and date is required..*\n"A first_name and last_name and dob, or an mrn is required. A subject event type and date is required./)
      
      # import errors
      # 
      # 
      # A subject event type and date is required.
      # A subject event type and date is required.
      # 
      # "A first_name and last_name and dob, or an mrn is required. 
      # "A first_name and last_name and dob, or an mrn is required. 
      # "A first_name and last_name and dob, or an mrn is required. 
      # A subject event type and date is required.
      # A subject event type and date is required.
      # "A first_name and last_name and dob, or an mrn is required. A subject event type and date is required.
    end

  end
end
