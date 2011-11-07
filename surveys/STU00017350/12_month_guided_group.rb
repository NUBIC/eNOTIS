Dir["#{Rails.root}/surveys/STU00017350/partials/*.rb"].each {|file| require file }
#require "#{Rails.root}/surveys/STU00017350/self_efficacy_for_weight_loss.rb"
#require "#{Rails.root}/surveys/STU00017350/self_reported_habit_strength_formation.rb"
#require "#{Rails.root}/surveys/STU00017350/promis_measure_qol.rb"
#require "#{Rails.root}/surveys/STU00017350/plans_for_money_earned_post_test.rb"
#require "#{Rails.root}/surveys/STU00017350/physical_measures_height_weight_bmi.rb"
#require "#{Rails.root}/surveys/STU00017350/physical_measures_waist_circ_blood_pressure.rb"
survey "12 month - Self-Guided" ,:irb_number=>'STU00017350' do
  #calling methods that represent sections defined as the separate modules
  self_efficacy_for_weight_loss 
  self_reported_habit_strength_formation
  promis_measure_qol
  plans_for_money_earned_post_test
  physical_measures_weight_waist_circumference_blood_pressure
end
