require 'spec_helper'

describe Empi::Exporter do
  before(:all) do
    EMPI_SERVICE = {:uri => 'http://fake.local', :credentials => 'fake'}
  end

  before(:each) do
    @a = Involvement.new(:subject => Subject.new, :study => Study.new(:read_only => false))
    @b = Involvement.new(:subject => Subject.new, :study => Study.new(:read_only => false))
    
    @client = mock
  end
  
  it "should complete successfully once" do
    @client.should_receive(:put).once
    instance.export_single(@a)
  end
  
  it "should complete successfully twice" do
    @client.should_receive(:put).any_number_of_times.with(any_args())
    instance([@a, @b]).export
  end
  
  def instance(involvements=nil)
    i = Empi::Exporter.new(involvements)
    i.stub!(:client).and_return(@client)
    i
  end
end