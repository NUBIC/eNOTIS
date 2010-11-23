require 'populator'
require 'faker'
require RAILS_ROOT + '/lib/faker/study'

# http://github.com/thoughtbot/factory_girl/tree/master
# http://faker.rubyforge.org/rdoc/
# http://github.com/ryanb/populator/tree/master

# Constants
DEATH_RATE = Array.new(195, false) + Array.new(5, true) # 5 in 200

# Basic Models
Factory.sequence :mrn do |n|
  "#{n+9998100}"
end

Factory.define :subject do |p|
  p.nmff_mrn                {Factory.next :mrn}
  p.nmh_mrn                 {Factory.next :mrn}
  p.ric_mrn                 {Factory.next :mrn}
  # p.source_system
  # p.pre_sync_data
  p.synced_at                 {3.minutes.ago}
  p.pre_sync_data             {nil}
  p.first_name                {"Pi"}
  p.middle_name               {"A"}
  p.last_name                 {"Patel"}
  p.death_date                {nil}
  p.address_line1             {"314 Circle Dr."}
  p.address_line2             {"Suite 159"}
  p.address_line3             {nil}
  p.city                      {"Garden City"}
  p.state                     {"GA"}
  p.zip                       {"31415"}
  p.phone_number              {"110 010 0100"}
  p.email                     {"pi@yatelp.com"}
  # p.no_contact                {}
  # p.no_contact_reason         {}
  
  # Actually setting the birth_date! Above method does not work
  #p.after_create { |u| u.birth_date = "1941-03-01"}
  #p.after_build { |u| u.birth_date = "1941-03-01"}
end

Factory.define :fake_subject, :parent => :subject do |p|
  # p.nmff_mrn
  # p.nmh_mrn
  # p.source_system
  # p.pre_sync_data
  p.synced_at                 {Populator.value_in_range(2.days.ago..2.minutes.ago)}
  p.first_name                {Faker::Name.first_name}
  p.middle_name               {Faker::Name.first_name}
  p.last_name                 {Faker::Name.last_name}
  p.birth_date                '02/19/1930'
#  p.birth_date                {Populator.value_in_range(70.years.ago..12.years.ago).to_date} 
  p.death_date                {|me| DEATH_RATE.rand ? Populator.value_in_range((((me.birth_date || 12.years.ago)+5.years).to_date)..(2.years.ago.to_date)) : nil}
  p.address_line1             {Faker::Address.street_address}
  p.address_line2             {Faker::Address.secondary_address}
  p.address_line3             {nil} 
  p.city                      {Faker::Address.city}
  p.state                     {Faker::Address.us_state}
  p.zip                       {Faker::Address.zip_code}
  p.phone_number              {Faker::PhoneNumber.phone_number.split(" x")[0]}
  p.email                     {Faker::Internet.email}
  # p.no_contact                
  # p.no_contact_reason         
 
 
end

Factory.sequence :irb_number do |n|
  "STU009999#{"%03d" % n}"
end

Factory.define :study do |p|
  p.irb_number            {Factory.next :irb_number}
  p.name                  {"Randomized Evaluation of Sinusitis With Vitamin A"}
  p.title                 {"Randomized Evaluation of Sinusitis With Vitamin A"}
  p.research_type         {}
  #p.description           {"Rem fugit culpa unde facilis earum. Quas et vitae ut cumque nihil quidem aperiam architecto. Et asperiores inventore non nisi libero architecto quibusdam.\r\n\r\nVeniam fugiat voluptas laudantium in assumenda. Blanditiis recusandae illum necessitatibus. Quia nesciunt esse officia neque doloribus vel explicabo provident. Non sit vero iusto quibusdam explicabo. Nobis in architecto quam pariatur sit autem optio."}
  p.irb_status            {"Approved"}
end

Factory.define :fake_study, :parent => :study do |p|
  p.title                 {Faker::Study.title}
  p.irb_number            {Factory.next :irb_number}
  p.name                  {|me| s = me.title.split; "#{s.first} #{s.last}";}
  p.research_type         {["Bio-medical","Bio-medical","Bio-medical","Social/Behavioral",""].rand}
  #p.description           {Faker::Lorem.paragraphs(3).join("\r\n")}
  p.irb_status            {Faker::Study.eirb_status}
end

Factory.sequence :email do |n|
  "user#{"%03d" % n}@northwestern.edu"
end

Factory.define :user do |u|
  u.first_name  'Test'
  u.last_name   'User'
  u.email       {Factory.next :email}
  u.netid       {|me| me.email.split("@")[0]}
end

Factory.define :fake_user, :parent => :user do |u|
  u.first_name  {Faker::Name.first_name}
  u.last_name   {Faker::Name.last_name}
  u.email       {|me| Factory.next(:email).gsub(/user/, "#{me.first_name.gsub(/[^a-zA-Z]/,'')[0,1]}#{me.last_name.gsub(/[^a-zA-Z]/,'')[0,2]}".downcase)}
  u.netid       {|me| me.email.split("@")[0]}
end

# Join/accessory models
Factory.define :involvement do |i|
  i.association   :subject
  i.association   :study
  i.ethnicity     {Involvement.ethnicities.rand}
  i.gender        {Involvement.genders.rand}
  i.races          {Involvement.races.rand}

end
Factory.define :event_type do |et|
  et.association :study
  et.name        {["Consented", "Withdrawn", "Screened", "Completed"].rand}
  et.editable    {[true, false, true].rand}
end

Factory.define :involvement_event do |e|
  e.association   :involvement
  e.association   :event_type
  e.note          {}
  e.occurred_on    {["today","yesterday"].rand}
end

Factory.define :role do |u|
  u.association   :user
  u.association   :study
  u.project_role {["PI","Principal Investigator","Co-Investigator","Coordinator","Co-INV","Statistican"].rand}
  u.consent_role {["Obtaining","Obtaining","Obtaining","Oversight","None",""].rand}
end

# This type of role will only be able to edit/view patients (ie accrue them)
Factory.define :role_accrues, :parent => :role do |u|
  u.association   :user
  u.association   :study
  u.project_role {["PI","Principal Investigator","Co-Investigator","Coordinator","Co-INV","Statistican"].rand}
  u.consent_role "Obtaining"
end

# This type of role will only be able to view patients and not edit them (ie no accrual privs)
Factory.define :role_views, :parent => :role do |u|
  u.association   :user
  u.association   :study
  u.project_role {["PI","Principal Investigator","Co-Investigator","Coordinator","Co-INV","Statistican"].rand}
  u.consent_role {["Oversight","None",""].rand}
end

Factory.define :study_upload do |s|
  s.association   :user
  s.association   :study
  s.upload        {File.open(File.dirname(__FILE__) + '/uploads/good.csv')}
  # s.upload_file_name        {"foo.csv"}
  # s.upload_content_type     {"text/csv"}
  # s.upload_file_size        {1023}
  # s.result_file_name        {"bar.csv"}
  # s.result_content_type     {"text/csv"}
  # s.result_file_size        {1023}
end
