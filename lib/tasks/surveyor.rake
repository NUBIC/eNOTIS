namespace :surveyor do 
  task :add_group => :environment do 
    raise "USAGE: file name required e.g. 'FILE=surveys/esophageal_group.YML'" if ENV["FILE"].blank?
    group_yml = YAML::load(File.read(File.join(RAILS_ROOT, ENV["FILE"])))
    survey_group = SurveyGroup.create(:access_code=>group_yml["survey_group"]["access_code"],:title=>group_yml["survey_group"]["title"],:progression=>group_yml["survey_group"]["progression"])
    group_yml["survey_group"]["surveys"].each do |s|
      str = File.read(File.join(RAILS_ROOT, s["file"]))
      survey = Surveyor::Parser.new.parse(str)
      survey_group.surveys << survey
      survey.save
      survey_group.save
    end
  end
end
