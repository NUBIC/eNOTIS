require 'spec_helper'

describe Empi::Exporter do
  before(:all) do
    EMPI_SERVICE = {:uri => 'http://fake.local', :credentials => 'fake'}
    Empi.stub!(:connect).and_return(true)
  end

  before(:each) do
    @a = Involvement.new(:subject => Subject.new, :study => Study.new(:read_only => false))
    @b = Involvement.new(:subject => Subject.new, :study => Study.new(:read_only => false))
    
    @client = mock
  end
  
  it "should complete successfully once" do
    Empi.should_receive(:put).once
    instance.export_single(@a)
  end
  
  it "should complete successfully twice" do
    Empi.should_receive(:put).twice
    instance([@a, @b]).export
  end
  
  def instance(involvements=nil)
    Empi::Exporter.new(involvements)
  end
end