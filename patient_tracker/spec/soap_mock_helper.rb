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

      # This is what is returned for a single row result... note the comment on multiple row responses:
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
      #              row= # <= if multiple rows then this is an array
      #                #<SOAP::Mapping::Object:0xc194ea {}
      #                  value=["STU00000706", 
      #                    "A randomized, rater-blinded, split-face comparison of the efficacy of Intense Pulse Light vs. Q-switched Nd:Yag laser for the treatment of melasma.", 
      #                    "Bio-medical", 
      #                    "A randomized, rater-blinded, split-face comparison of the efficacy of Intense Pulse Light vs. Q-switched Nd:Yag laser for the treatment of melasma.", 
      #                    "_Study", 
      #                    "1/1/1800 2:00:00 AM", 
      #                    "Melasma is a common acquired condition of circumscribed hyperpigmentation that is usually progressive and lasts for many years and is difficult to treat. This study will further evaluate the Q-switched Nd: YAG laser operating at 1064 nm in comparison to intense pulse light in the treatment of melasma lesions. To adequately assess this laser treatment, it will be compared to intense pulsed light. IPL will be used to comparatively evaluate the efficacy of laser treatment because it has shown promise in treating melasma . This study is a randomized, double-blind, single-center prospective clinical study of 20 subjects. Participants in this study will be subjects at the dermatology clinic who are clinically diagnosed with melasma. One half of the subject\342\200\231s face will be assigned to receive a total of 3 treatments of Q-switched Nd:Yag laser and the other half of the face will be assigned to receive a total of 3 treatments 0f IPL. The treatment will be conducted at each of weeks 0, 5, and 10 (ie, one treatment on each visit). There will be a follow up visit at 15 weeks to asses the treatment efficacy. Baseline digital photography will be taken at each of these visits. The clinician will assess the subject\342\200\231s melasma using the Melasma Area and Severity Index (MASI) at the baseline visit and at the 15 weeks follow up visit. The subject will also be asked to complete the Melasma Quality of Life questionnaire (MELASQOL) at these visits.",
      #                    "Approved"]
      #            >
      #            >
      #        >
      #    >
      #>
    #
    # This is what is returned for a single row with a value list result
      # #<SOAP::Mapping::Object:0x2a2b1b8 {http://clickcommerce.com/Extranet/WebServices}
      #    performSearchResult=
      #      #<SOAP::Mapping::Object:0x2a2af74 {}
      #        searchResults=
      #          #<SOAP::Mapping::Object:0x2a2ae48 {}
      #            description="Returns the access list given a study, or all study access lists given null" {}  
      #            columnHeaders=
      #              #<SOAP::Mapping::Object:0x2a29fca {}
      #                  columnHeader=["ID", "Contacts.User ID"]
      #              > {}
      #            resultSet=
      #              #<SOAP::Mapping::Object:0x2a271d0 {}
      #                row=  
      #                  #<SOAP::Mapping::Object:0x2a26dc0 {}
      #                    value="STU00002629" {}
      #                    valueList=
      #                      #<SOAP::Mapping::Object:0x2a2464c {}
      #                        value=["kaz266", "slr919"]
      #                      >
      #                   >
      #               >
      #           >
      #       >
      #   >
                  
    def self.make_column_headers(payload)
      if payload.first.is_a?(Array)
        template = payload.first
      else
        template = payload
      end
      template.map{|hash| hash.keys.first.to_s}
    end

    def self.make_resultSet_values(payload)
      payload.map{|hash| hash.values.first.to_s}
    end
    
    def self.make_mock_header(payload)
      header = Mock.new(SOAP::Mapping::Object)
      header.stub!(:columnHeader).and_return(Search.make_column_headers(payload))
      header
    end

    def self.make_mock_row(payload)
      rows = []
      if payload.first.is_a?(Array)
        payload.each do |i|
          row = Mock.new(SOAP::Mapping::Object)
          row.stub!(:value).and_return(Search.make_resultSet_values(i))
          rows << row
        end
        return rows
      else
        row = Mock.new(SOAP::Mapping::Object)
        row.stub!(:value).and_return(Search.make_resultSet_values(payload))
        return row
      end
    end
    
    def results(payload = [])
      #mocking out the ugliness that is the soap return object
      search_result = Mock.new(SOAP::Mapping::Object)
      search_result.stub!(:description).and_return("")

      cols =  Mock.new(SOAP::Mapping::Object)
      cols.stub!(:columnHeader).and_return(Search.make_column_headers(payload))
      search_result.stub!(:columnHeaders).and_return(cols)
     
      res_set = Mock.new(SOAP::Mapping::Object)
      res_set.stub!(:row).and_return(Search.make_mock_row(payload))
      search_result.stub!(:resultSet).and_return(res_set)

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
      @payload = [{:ID => "STU0912301239"},
        {"Project State.ID" => "APPROVED"}, 
        {"Name" => "The research study"},
        {"Research Type.ID" => "INTERVENTIONAL"},
        {"Contacts.User ID" => "ntu123"}]
      @correct_headers = ["ID", "Project State.ID", "Name", "Research Type.ID","Contacts.User ID"]
      @correct_values =  ["STU0912301239","APPROVED","The research study","INTERVENTIONAL", "ntu123"] 
    end
    
    it "converts a payload array of hash objects into 'columnHeaders'" do
      SoapMockHelper::Search.make_column_headers(@payload).should == @correct_headers
    end

    it "converts a payload with multiple arrays into column headers" do
      SoapMockHelper::Search.make_column_headers([@payload,@payload]).should == @correct_headers
    end

    it "converts a payload array of hash objects in to 'resultSet' values" do 
      SoapMockHelper::Search.make_resultSet_values(@payload).should == @correct_values
    end
  
    it "makes a column heading soap Object with the columnHeader data" do
      mock_obj = SoapMockHelper::Search.make_mock_header(@payload)  
      mock_obj.respond_to?(:columnHeader).should be_true
      mock_obj.columnHeader.should == @correct_headers
    end   

    it "makes a row obj with one value for one payload row" do
      mock_obj = SoapMockHelper::Search.make_mock_row(@payload)  
      mock_obj.respond_to?(:value).should be_true
      mock_obj.value.should == @correct_values
    end
    
    it "makes a row obj as an array for multiple payload rows" do
      mock_obj = SoapMockHelper::Search.make_mock_row([@payload,@payload]) 
      mock_obj.is_a?(Array).should be_true
      mock_obj.first.respond_to?(:value).should be_true
      mock_obj.second.respond_to?(:value).should be_true
      mock_obj.first.value.should == @correct_values
      mock_obj.second.value.should == @correct_values
    end

    it "makes a resultSet object with the value data embedded" do
      mock_obj = SoapMockHelper::Search.new.results(@payload)
      mock_obj.performSearchResult.searchResults.respond_to?(:resultSet).should be_true
      mock_obj.performSearchResult.searchResults.resultSet.respond_to?(:row).should be_true 
      mock_obj.performSearchResult.searchResults.respond_to?(:columnHeaders).should be_true
      mock_obj.performSearchResult.searchResults.columnHeaders.respond_to?(:columnHeader).should be_true
    end

  end

end
