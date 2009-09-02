require 'edw_adapter'
require 'edw_translations'
class EdwServices
  
  cattr_accessor :edw_adapter
  
  # initializing the EDW connection
  def self.connect
    yml = File.open(File.join(RAILS_ROOT,"config/edw_services.yml"))
    config = ServiceConfig.new(RAILS_ENV, YAML.parse(yml))
    self.edw_adapter = EdwAdapter.new(config)
  end

  def self.service_test()
    #get test mrnA
    yml = File.open(File.join(RAILS_ROOT,"config/edw_services.yml"))
    config = ServiceConfig.new(RAILS_ENV, YAML.parse(yml))
    begin
      result = find_by_mrn({:mrn=>config.test_mrn})
      status = result[:mrn] == config.test_mrn
      return status, status ? "All good" : "Invalid data returned"
    rescue => error
      return false,error.message
    end
  end


  # Subject mode
  def self.find_by_mrd_pt_id(conditions)
    connect
    result = edw_adapter.perform_search(convert_for_edw(conditions))
    convert_for_notis(result)
  end
  def self.find_by_mrn(conditions)
    connect
    result = edw_adapter.perform_search(convert_for_edw(conditions))
    convert_for_notis(result)
  end

  def self.find_by_name_and_dob(conditions)
    connect
    result = edw_adapter.perform_search(convert_for_edw(conditions))
    convert_for_notis(result)
  end
  
  def self.find_by_last_name_first_name_and_birth_date(conditions)
    connect
    result = edw_adapter.perform_search(convert_for_edw(conditions))
    convert_for_notis(result)
  end

  def self.convert_for_notis(values)
    convert(values,EDW_TO_NOTIS)
  end

  def self.convert_for_edw(values)
    convert([values],NOTIS_TO_EDW).first
  end
  private
  def self.convert(values,converter)
      results=[]
      return values unless !values.nil?
      values.each do |val|
        result ={}
        val.each do |key,value|
	  result[converter[key.to_s].to_sym] = value unless !converter.has_key?key.to_s
        end
        results << result
      end
      return results
  end


end




