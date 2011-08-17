Dir["#{Rails.root}/surveys/STU00017350/partials/*.rb"].each {|file| require file }
survey "Baseline",:irb_number=>'STU00017350' do
  #calling methods that represent sections defined as the separate modules
  demographics
  self_efficacy_for_weight_loss
  self_reported_habit_strength_formation
  promis_measure_qol
  plans_for_money_earned_pre_test
  technology_literacy
  technology_anxiety
  condition_preference_pre_test
end
