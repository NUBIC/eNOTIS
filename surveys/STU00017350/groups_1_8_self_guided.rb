Dir["#{Rails.root}/surveys/STU00017350/partials/*.rb"].each {|file| require file }
survey "Groups 1-8 - Guided Group (DVD)",:irb_number=>'STU00017350' do
  #calling methods that represent sections defined as the separate modules
  physical_measures_height_weight_bmi
end
