Dir["#{Rails.root}/surveys/STU00017350/partials/*.rb"].each {|file| require file }
#require File.expand_path(File.dirname(__FILE__) + "/surveys/self_efficacy_for_weight_loss.rb")
#require File.expand_path(File.dirname(__FILE__) + "/surveys/self_reported_habit_strength_formation.rb")
#require File.expand_path(File.dirname(__FILE__) + "/surveys/promis_measure_qol.rb")
#require File.expand_path(File.dirname(__FILE__) + "/surveys/dpp_group_lifestyle_balance_materials.rb")
#require File.expand_path(File.dirname(__FILE__) + "/surveys/physical_measures_height_weight_bmi.rb")
#require File.expand_path(File.dirname(__FILE__) + "/surveys/physical_measures_waist_circ_blood_pressure.rb")
survey "3 month - Self-Guided",:irb_number=>'STU00017350' do
  #calling methods that represent sections defined as the separate modules
  self_efficacy_for_weight_loss 
  self_reported_habit_strength_formation
  promis_measure_qol
  dpp_group_lifestyle_balance_materials  
end
