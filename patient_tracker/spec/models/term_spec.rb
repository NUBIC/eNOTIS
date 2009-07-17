require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Term do
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
      t = Term.create(:code => "blah")
      t.should have(1).error_on(:term)
      t = Term.create(:term => "blah")
      t.should have(1).error_on(:code)
    end

    it "requires term and code be unique for a category" do
      @t = Term.create(@valid_attributes)
      dup = Term.create(@valid_attributes)
      dup.should have(1).error_on(:term)
      dup.should have(1).error_on(:code)
      dup.valid?.should be_false
      alt = Term.create(@valid_attributes.merge!({:category => "other"}))
      alt.valid?.should be_true
    end
  end

  describe "common usage interface" do
    before(:each) do
      @t = Term.create(@valid_attributes)
      Term.find(:all).size.should == 1
    end
      
    it "returns the 'user friendly' value when turned into a string" do
      @t.to_s.should == "Klingon" 
      "#{@t}".should == "Klingon"
    end

    it "finds a term given code and category" do
      t = Term.lookup_code(:klon,:race)
      t.should == @t
    end

    it "finds a term given the term and category" do
      t = Term.lookup_term("Klingon",:race)
      t.should == @t
    end

    it "finds all the terms for a particular source" do
      Term.create({:term => "foo",:code => "foo",:category => "all", :source => "The internets"})
      Term.create({:term => "bar",:code => "bar",:category => "all", :source => "United Federation Race Categories"})
      s = Term.source_terms("United Federation Race Categories")
      s.size.should == 2
    end

  end
end
