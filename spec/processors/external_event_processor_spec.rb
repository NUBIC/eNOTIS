require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')



describe ExternalEventProcessor do 

  before(:each) do
    @processor = ExternalEventProcessor.new()
    @study = Factory(:fake_study)
  end

  it "Should process and event properly when it receives one" do
    params = {:study=>{:irb_number=>@study.irb_number}, :subject=>{:mrn=>'1234', :mrn_type=>"NMH",:birth_date=>"1988-11-02", :last_name=>"kabaka", :middle_name=>"man",:first_name=>"daudi"}, :involvement=>{:case_number=>"12345",:gender=>"male", :race_is_asian=>"T", :ethnicity=>"Hispanic Or Latino"}, :involvement_events=>[{:occurred_on=>"2010-11-18", :note=>"generated from Registar - Asthma and COPD Patient Registry", :event=>"consented"}]}
    crypted_params = @processor.encrypt(params)
    @processor.on_message(crypted_params.to_json)
    @study.involvements.size.should == 1
    involvement = @study.involvements.first
    involvement.subject.mrn.should=="1234"
    involvement.subject.mrn_type.should=="NMH"
    involvement.subject.last_name.should=="kabaka"
    involvement.subject.first_name.should=="daudi"
    involvement.subject.middle_name.should=="man"
    involvement.case_number=="12345"
    involvement.gender.should=="Male"
    involvement.race_is_asian.should == true
    involvement.ethnicity.should=="Hispanic or Latino"
    involvement.involvement_events.size.should == 1
    event = involvement.involvement_events.first
    event.event.should =="Consented"
    event.occurred_on.to_date.should == Chronic.parse("2010-11-18").to_date
  end


end
