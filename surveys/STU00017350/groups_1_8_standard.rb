Dir["#{Rails.root}/surveys/STU00017350/partials/*.rb"].each {|file| require file }
#require File.expand_path(File.dirname(__FILE__) + "/surveys/physical_measures_height_weight_bmi.rb")
survey "Groups 1-8 - Standard",:irb_number=>'STU00017350' do
  #calling methods that represent sections defined as the separate modules
  physical_measures_height_weight_bmi
end
