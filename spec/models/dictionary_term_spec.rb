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
      t = DictionaryTerm.create(:code => "blah")
      t.should have(1).error_on(:term)
      t = DictionaryTerm.create(:term => "blah")
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

  describe "common usage interface" do
    before(:each) do
      # We are now pre-populating the DictionaryTerms in spec_helper.rb in order to support other specs that use factories.
      @x = DictionaryTerm.count
      @t = DictionaryTerm.create(@valid_attributes)
      DictionaryTerm.find(:all).size.should == (@x+1)
    end
      
    it "returns the 'user friendly' value when turned into a string" do
      @t.to_s.should == "Klingon" 
      "#{@t}".should == "Klingon"
    end

    it "finds a term given code and category" do
      t = DictionaryTerm.lookup_code(:klon,:race)
      t.should == @t
    end

    it "finds a term given the term and category" do
      t = DictionaryTerm.lookup_term("Klingon",:race)
      t.should == @t
    end

    it "finds all the terms for a particular source" do
      DictionaryTerm.create({:term => "foo",:code => "foo",:category => "all", :source => "The internets"})
      DictionaryTerm.create({:term => "bar",:code => "bar",:category => "all", :source => "United Federation Race Categories"})
      s = DictionaryTerm.source_terms("United Federation Race Categories")
      s.size.should == 2
    end

  end
end
