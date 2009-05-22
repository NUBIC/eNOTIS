require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
gem 'soap4r', '>=1.5.8'
require 'soap/wsdlDriver'
require 'spec/mocks'

module SoapMockHelper
  class Search 
    include Spec::Mocks
    
      #This is what is returned for an empty result:
      ##<SOAP::Mapping::Object:0xcce17e {http://clickcommerce.com/Extranet/WebServices}
      #  performSearchResult=
      #    #<SOAP::Mapping::Object:0xcce106 {}
      #      searchResults=
      #        #<SOAP::Mapping::Object:0xcce08e {}
      #          description="" {}
      #          columnHeaders=
      #            #<SOAP::Mapping::Object:0xccdc92 {}
      #              columnHeader=["ID", "Project State.ID"]
      #            > {}
      #          resultSet=""
      #        >
      #    >
      #>
      # This is what is returned for a single row result:
      ##<SOAP::Mapping::Object:0xc1c758 {http://clickcommerce.com/Extranet/WebServices}
      #  performSearchResult=
      #    #<SOAP::Mapping::Object:0xc1c6d6 {}
      #      searchResults=
      #        #<SOAP::Mapping::Object:0xc1c640 {}
      #          description="Finds basic study info using the Study ID" {}
      #          columnHeaders=
      #            #<SOAP::Mapping::Object:0xc1c0f0 {}
      #              columnHeader=["ID", "Name", "Research Type.Name", "Study Title", "Type", "Activated Date", "Description", "Project State.ID"]
      #             > {}
      #          resultSet=
      #            #<SOAP::Mapping::Object:0xc19576 {}
      #              row=
      #                #<SOAP::Mapping::Object:0xc194ea {}
      #                  value=["STU00000706", 
      #                    "A randomized, rater-blinded, split-face comparison of the efficacy of Intense Pulse Light vs. Q-switched Nd:Yag laser for the treatment of melasma.", 
      #                    "Bio-medical", 
      #                    "A randomized, rater-blinded, split-face comparison of the efficacy of Intense Pulse Light vs. Q-switched Nd:Yag laser for the treatment of melasma.", 
      #                    "_Protocol", 
      #                    "1/1/1800 2:00:00 AM", 
      #                    "Melasma is a common acquired condition of circumscribed hyperpigmentation that is usually progressive and lasts for many years and is difficult to treat. This study will further evaluate the Q-switched Nd: YAG laser operating at 1064 nm in comparison to intense pulse light in the treatment of melasma lesions. To adequately assess this laser treatment, it will be compared to intense pulsed light. IPL will be used to comparatively evaluate the efficacy of laser treatment because it has shown promise in treating melasma . This study is a randomized, double-blind, single-center prospective clinical study of 20 subjects. Participants in this study will be patients at the dermatology clinic who are clinically diagnosed with melasma. One half of the subject\342\200\231s face will be assigned to receive a total of 3 treatments of Q-switched Nd:Yag laser and the other half of the face will be assigned to receive a total of 3 treatments 0f IPL. The treatment will be conducted at each of weeks 0, 5, and 10 (ie, one treatment on each visit). There will be a follow up visit at 15 weeks to asses the treatment efficacy. Baseline digital photography will be taken at each of these visits. The clinician will assess the subject\342\200\231s melasma using the Melasma Area and Severity Index (MASI) at the baseline visit and at the 15 weeks follow up visit. The subject will also be asked to complete the Melasma Quality of Life questionnaire (MELASQOL) at these visits.",
      #                    "Approved"]
      #                >
      #            >
      #        >
      #    >
      #>
            
    def self.make_column_headers(payload)
      payload.map{|hash| hash.keys.first.to_s}
    end

    def self.make_resultSet_values(payload)
      payload.map{|hash| hash.values.first.to_s}
    end
    
    def self.make_mock_header(payload)
      header = Mock.new(SOAP::Mapping::Object)
      header.stub!(:columnHeader).and_return(Search.make_column_headers(payload))
      header
    end

    def results(payload = [])
      #mocking out the ugliness that is the soap return object
      search_result = Mock.new(SOAP::Mapping::Object)
      search_result.stub!(:description).and_return("")

      search_result.stub!(:columnHeaders)
      
      search_result.stub!(:resultSet)

      perform_search_result = Mock.new(SOAP::Mapping::Object)
      perform_search_result.stub!(:searchResults).and_return(search_result)

      result= Mock.new(SOAP::Mapping::Object)
      result.stub!(:performSearchResult).and_return(perform_search_result)
      return result
    end
  end
end

describe SoapMockHelper do
  before(:each) do
    @test_obj = SoapMockHelper::Search.new.results
  end

  it "has a performSearchResult attribute" do
    @test_obj.respond_to?(:performSearchResult).should be_true
  end

  describe "performSearchResult attribute >>" do

    it "has a searchResults attribute" do
      @test_obj.performSearchResult.respond_to?(:searchResults).should be_true
    end

    describe "searchResults attribute >>" do

      it "has a search description" do
        @test_obj.performSearchResult.searchResults.respond_to?(:description).should be_true
      end

      it "has a columnHeaders attribute" do
        @test_obj.performSearchResult.searchResults.respond_to?(:columnHeaders).should be_true
      end

      it "has a resultSet attribute" do
        @test_obj.performSearchResult.searchResults.respond_to?(:resultSet).should be_true
      end
    end
  end

  describe "formatting result set mock objects" do
    before(:each) do
      @payload = [{:ID => "STU0912301239"}, {"Project State.ID" => "APPROVED"}, {"Name" => "The research study"}, {"Research Type.ID" => "INTERVENTIONAL"}]
      @correct_headers = ["ID", "Project State.ID", "Name", "Research Type.ID"]
      @correct_values =  ["STU0912301239","APPROVED","The research study","INTERVENTIONAL"] 
    end
    
    it "converts a payload array of hash objects into 'columnHeaders'" do
      SoapMockHelper::Search.make_column_headers(@payload).should == @correct_headers
    end

    it "converts a payload array of hash objects in to 'resultSet' values" do 
      SoapMockHelper::Search.make_resultSet_values(@payload).should == @correct_values
    end
  
    it "makes a column heading soap Object with the columnHeader data" do
      mock_obj = SoapMockHelper::Search.make_mock_header(@payload)  
      mock_obj.respond_to?(:columnHeader).should be_true
      mock_obj.columnHeader.should == @correct_headers
    end

    
  end
end
