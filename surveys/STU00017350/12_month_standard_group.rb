Dir["#{Rails.root}/surveys/STU00017350/partials/*.rb"].each {|file| require file }
#require "#{Rails.root}/surveys/STU00017350/self_efficacy_for_weight_loss.rb"
#require "#{Rails.root}/surveys/STU00017350/self_reported_habit_strength_formation.rb"
#require "#{Rails.root}/surveys/STU00017350/group_cohesion.rb"
#require "#{Rails.root}/surveys/STU00017350/promis_measure_qol.rb"
#require "#{Rails.root}/surveys/STU00017350/plans_for_money_earned_post_test.rb"
#require "#{Rails.root}/surveys/STU00017350/perceived_autonomy_support_given.rb"
#require "#{Rails.root}/surveys/STU00017350/perceived_autonomy_support_received.rb"
#require "#{Rails.root}/surveys/STU00017350/therapeutic_alliance.rb"
#require File.expand_path(File.dirname(__FILE__) + "/surveys/physical_measures_height_weight_bmi.rb")
#require File.expand_path(File.dirname(__FILE__) + "/surveys/physical_measures_waist_circ_blood_pressure.rb")
survey "12 month - Standard Group (Paper Pencil)" ,:irb_number=>'STU00017350' do
  #calling methods that represent sections defined as the separate modules
  self_efficacy_for_weight_loss 
  self_reported_habit_strength_formation
  group_cohesion
  promis_measure_qol
  plans_for_money_earned_post_test
  perceived_autonomy_support_given
  perceived_autonomy_support_received  
  therapeutic_alliance
  physical_measures_height_weight_bmi
  physical_measures_waist_circumference_blood_pressure
end
