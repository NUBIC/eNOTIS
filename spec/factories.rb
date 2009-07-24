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

  p.mrn                       {Factory.next :mrn}
  p.mrn_type                  {"Cerner"}
  p.synced_at               {3.minutes.ago}
  p.pre_sync_data             {nil}
  p.first_name                {"Pi"}
  p.middle_name               {"A"}
  p.last_name                 {"Patel"}
  p.birth_date                {Date.parse('1941-03-01')} # 3/1/41
  p.death_date                {nil}
  p.address_line1             {"314 Circle Dr."}
  p.address_line2             {"Suite 159"}
  p.address_line3             {nil}
  p.city                      {"Garden City"}
  p.state                     {"GA"}
  p.zip                       {"31415"}
  p.phone_number              {"110 010 0100"}
  p.email                     {"pi@yatelp.com"}
end

Factory.define :fake_subject, :parent => :subject do |p|
  # p.mrn
  p.mrn_type                  {["Epic", "Cerner"].rand}
  p.synced_at               {Populator.value_in_range(2.days.ago..2.minutes.ago)}
  p.first_name                {Faker::Name.first_name}
  p.middle_name               {Faker::Name.first_name}
  p.last_name                 {Faker::Name.last_name}
  p.birth_date                {Populator.value_in_range(80.years.ago..15.years.ago)}
  p.death_date                {|me| DEATH_RATE.rand ? Populator.value_in_range((me.birth_date+10.years)..3.years.ago) : nil}
  p.address_line1             {Faker::Address.street_address}
  p.address_line2             {Faker::Address.secondary_address}
  p.address_line3             {nil} 
  p.city                      {Faker::Address.city}
  p.state                     {Faker::Address.us_state}
  p.zip                       {Faker::Address.zip_code}
  p.phone_number              {Faker::PhoneNumber.phone_number.split(" x")[0]}
end

Factory.sequence :irb_number do |n|
  "STU009999#{"%03d" % n}"
end

Factory.define :study do |p|
  p.irb_number            {Factory.next :irb_number}
  p.name                  {"Randomized Evaluation of Sinusitis With Vitamin A"}
  p.title                 {"Randomized Evaluation of Sinusitis With Vitamin A"}
  p.research_type         {}
  p.phase                 {"II"}
  p.description           {"Rem fugit culpa unde facilis earum. Quas et vitae ut cumque nihil quidem aperiam architecto. Et asperiores inventore non nisi libero architecto quibusdam.\r\n\r\nVeniam fugiat voluptas laudantium in assumenda. Blanditiis recusandae illum necessitatibus. Quia nesciunt esse officia neque doloribus vel explicabo provident. Non sit vero iusto quibusdam explicabo. Nobis in architecto quam pariatur sit autem optio."}
  p.status                {"Approved"}
  p.pi_netid              {"tuh532"}
  p.pi_first_name         {"Terry"}
  p.pi_last_name          {"Hulu"}
  p.pi_email              {"t-hulu@northwestern.edu"}
  p.sc_netid              {"cab133"}
  p.sc_first_name         {"Carter"}
  p.sc_last_name          {"Baggs"}
  p.sc_email              {"cbaggs@northwestern.edu"}
  p.synced_at       {3.minutes.ago}
end

Factory.define :fake_study, :parent => :study do |p|
  p.title                 {Faker::Study.title}
  p.name                  {|me| s = me.title.split; "#{s.first} #{s.last}";}
  p.research_type         {["Bio-medical","Bio-medical","Bio-medical","Social/Behavioral",""].rand}
  p.phase                 {["I","II","III","IV","n/a",nil].rand}
  p.description           {Faker::Lorem.paragraphs(3).join("\r\n")}
  p.status                {Faker::Study.eirb_status}
  p.pi_first_name         {Faker::Internet.email}
  p.pi_last_name          {Faker::Name.last_name}
  p.pi_email              {Faker::Internet.email}
  p.pi_netid              {|me| "#{me.pi_first_name.gsub(/[^a-zA-Z]/,'')[0,1]}#{me.pi_last_name.gsub(/[^a-zA-Z]/,'')[0,2]}#{(100..999).to_a.rand}".downcase}
  p.sc_first_name         {Faker::Name.first_name}
  p.sc_last_name          {Faker::Name.last_name}
  p.sc_email              {Faker::Internet.email}
  p.sc_netid              {|me| "#{me.sc_first_name.gsub(/[^a-zA-Z]/,'')[0,1]}#{me.sc_last_name.gsub(/[^a-zA-Z]/,'')[0,2]}#{(100..999).to_a.rand}".downcase}
  p.synced_at       {Populator.value_in_range(2.days.ago..2.minutes.ago)}
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
end

Factory.define :involvement_event do |e|
  e.association   :involvement
  e.key          {"event_type"}
  e.value        {%w(consented enrolled withdrawn screened randomized approached).rand}
  e.occured_on   {2.weeks.ago}
end

Factory.define :involvement_data do |e|
  e.association   :involvement
  e.key          {%w(race gender ethnicity).rand}
  e.value        {%w(consented enrolled withdrawn screened randomized approached).rand}
end

Factory.define :coordinator do |u|
  u.association             :user
  u.association             :study
end

Factory.define :study_upload do |s|
  s.association             :user
  s.association             :study
  s.upload                  {File.open(File.dirname(__FILE__) + '/uploads/good.csv')}
  # s.upload_file_name        {"foo.csv"}
  # s.upload_content_type     {"text/csv"}
  # s.upload_file_size        {1023}
  # s.result_file_name        {"bar.csv"}
  # s.result_content_type     {"text/csv"}
  # s.result_file_size        {1023}
  
end