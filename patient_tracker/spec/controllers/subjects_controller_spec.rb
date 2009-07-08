require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SubjectsController do
  describe "importing csv" do
    before(:each) do      
      dir = File.dirname(__FILE__) + '/../uploads/'
      @current_user = User.create
      @good_csv = File.open(dir + 'good.csv')
      @bad_csv = File.open(dir + 'bad.csv')
      @good_random_cols_csv = File.open(dir + 'good_random_cols.csv')
      @bad_random_cols_csv = File.open(dir + 'bad_random_cols.csv')
      controller.stub!(:user_must_be_logged_in)
      controller.stub!(:current_user).and_return(@current_user)
    end
    
    it "should allow me to post the file to create" do
      controller.class.stub!(:csv_sanity_check).and_return(true)
      post :create, {:file => @good_csv}
      response.should redirect_to(studies_path)
      post :create, {:file => @good_csv, :study_id => 3}
      response.should redirect_to(study_path(:id => 3))
    end
  
    it "should create a new StudyUpload with the file attached" do
      controller.class.stub!(:csv_sanity_check).and_return(true)
      StudyUpload.should_receive(:create).with({:upload => @good_csv, :study_id => "3",:user_id=>1}).and_return(Factory(:study_upload))
      post :create, {:file => @good_csv, :study_id => 3}
    end
    it "should sanity check csv file for mrn or (first_name, last_name, dob), and (subject_event_type, subject_event_date)" do
      controller.class.csv_sanity_check(@good_csv).should be_true
      controller.class.csv_sanity_check(@bad_csv).should be_false
    end
    it "should sanity check csv file for mrn or (first_name, last_name, dob), and (subject_event_type, subject_event_date) with columns in random order" do
      controller.class.csv_sanity_check(@good_random_cols_csv).should be_true
      controller.class.csv_sanity_check(@bad_random_cols_csv).should be_false
    end
    it "should sanityf check a csv file or string or Paperclip::Attachement" do
      controller.class.csv_sanity_check(@bad_csv).should be_false
      controller.class.csv_sanity_check(@good_csv.read.to_s).should be_true
      controller.class.csv_sanity_check(StudyUpload.new(:upload => @bad_random_cols_csv).upload).should be_false
    end
    it "should sanity check csv file (success) and queue up the file and redirect to study" do
      controller.class.should_receive(:csv_sanity_check).and_return(true)
      post :create, {:file => @good_csv, :study_id => 3}
      response.should redirect_to(study_path(:id => 3))
    end
    it "should sanity check csv file (success) and queue up the file and redirect to studies path" do
      controller.class.should_receive(:csv_sanity_check).and_return(true)
      post :create, {:file => @good_csv}
      response.should redirect_to(studies_path)
    end
    it "should sanity check csv file (failure) and send me back a csv file" do
      controller.class.should_receive(:csv_sanity_check).and_return(false)
      post :create, {:file => @bad_csv, :study_id => 3}
      response.headers['Content-type'].should match(/text\/csv/)
      response.headers['Content-Disposition'].should match(/attachment; filename='.*-result\.csv'/)
    end
    it "should sanity check csv file (failure) and send me back a csv file for IE" do
      # http://www.calicowebdev.com/blog/show/21
      controller.class.should_receive(:csv_sanity_check).and_return(false)
      request.env['HTTP_USER_AGENT'] = "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)"
      post :create, {:file => @bad_csv, :study_id => 3}
      response.headers['Content-Disposition'].should match(/attachment; filename='.*-result\.csv'/)
      response.headers['Pragma'].should == 'public'
      response.headers['Content-type'].should match(/text\/plain/)
      response.headers['Cache-Control'].should == 'no-cache, must-revalidate, post-check=0, pre-check=0'
      response.headers['Expires'].should == '0'
    end
    it "should sanity check csv file (failure) and send me back a csv file with a 'import errors' as first header, and a valid column of input errors" do
      
      post :create, {:file => @bad_csv,:study_id=>3}
      response.body.should match(/^import_errors.*\n.*\n.*\nA subject event type and date is required..*\nA subject event type and date is required..*\n.*\n"A first_name and last_name and birth_date, or an mrn is required. .*\n"A first_name and last_name and birth_date, or an mrn is required. .*\n"A first_name and last_name and birth_date, or an mrn is required. .*\nA subject event type and date is required..*\nA subject event type and date is required..*\n"A first_name and last_name and birth_date, or an mrn is required. A subject event type and date is required./)
      
      # import errors
      # 
      # 
      # A subject event type and date is required.
      # A subject event type and date is required.
      # 
      # "A first_name and last_name and birthdate, or an mrn is required. 
      # "A first_name and last_name and dob, or an mrn is required. 
      # "A first_name and last_name and dob, or an mrn is required. 
      # A subject event type and date is required.
      # A subject event type and date is required.
      # "A first_name and last_name and dob, or an mrn is required. A subject event type and date is required.
    end  
  end
end
