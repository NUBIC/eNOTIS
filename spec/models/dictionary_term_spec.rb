require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DictionaryTerm do
  before(:each) do
    @valid_attributes = {
      :term => "Klingon",
      :code => "klon",
      :category => "race",
      :source => "United Federation Race Categories",
      :description => "A warrior race in the fictional Star Trek universe."
    }
  end
  
  describe "validations" do
    it "requires term and code" do
      t = DictionaryTerm.new(:code => "blah")
      t.should have(1).error_on(:term)
      t = DictionaryTerm.new(:term => "blah")
      t.should have(1).error_on(:code)
    end

    it "requires term and code be unique for a category" do
      @t = DictionaryTerm.create(@valid_attributes)
      dup = DictionaryTerm.create(@valid_attributes)
      dup.should have(1).error_on(:term)
      dup.should have(1).error_on(:code)
      dup.valid?.should be_false
      alt = DictionaryTerm.create(@valid_attributes.merge!({:category => "other"}))
      alt.valid?.should be_true
    end
  end

  describe "finds a term given the term and category" do
    @t = DictionaryTerm.create(@valid_attributes)
    %w(KlinGON KLINGON klingon).each do |c|
      it "is case insensitive for code: #{c}" do
        t = DictionaryTerm.race(c)
        t.should == @t
      end
    end
  end
end
