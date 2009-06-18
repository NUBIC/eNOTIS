require 'populator'
require 'faker'
require 'lib/faker/protocol'

# http://github.com/thoughtbot/factory_girl/tree/master
# http://faker.rubyforge.org/rdoc/
# http://github.com/ryanb/populator/tree/master

# Constants
LOST_RATE = Array.new(99, false) + Array.new(1, true) # 1 in 100
DEATH_RATE = Array.new(195, false) + Array.new(5, true) # 5 in 200

# Basic Models

Factory.sequence :mrn do |n|
  "#{n+9988100}"
end

Factory.define :subject do |p|

  p.mrn                       {Factory.next :mrn}
  p.mrn_type                  {"Cerner"}
  p.source                    {"EDW"}
  p.last_reconciled           {3.minutes.ago}
  p.reconcile_status          {nil}
  p.first_name                {"Pi"}
  p.last_name                 {"Patel"}
  p.lost_to_follow_up         {false}
  p.lost_to_follow_up_reason  {nil}
  p.birth_date                {Date.parse('1941-03-01')} # 3/1/41
  p.death_date                {nil}
  p.address_line1             {"314 Circle Dr."}
  p.address_line2             {"Suite 159"}
  p.city                      {"Garden City"}
  p.state                     {"GA"}
  p.zip                       {"31415"}
  p.phone                     {"110 010 0100"}
  p.work_phone                {"180 180 1801"}
  p.work_phone_extension      {"801"}
end

Factory.alias("last_synced", "last_reconciled")
Factory.alias("sync_status", "reconcile_status")


Factory.define :fake_subject, :parent => :subject do |p|
  # p.mrn
  p.mrn_type                  {["Epic", "Cerner"].rand}
  p.source                    {(Array.new(10, "EDW") + ["Local"]).rand}
  p.last_reconciled           {Populator.value_in_range(2.days.ago..2.minutes.ago)}
  # p.reconcile_status
  p.first_name                {Faker::Name.first_name}
  p.last_name                 {Faker::Name.last_name}
  p.lost_to_follow_up         {LOST_RATE.rand}
  p.lost_to_follow_up_reason  {|me| me.lost_to_follow_up ? ["oops!", "doh!"].rand : nil}
  p.birth_date                {Populator.value_in_range(80.years.ago..15.years.ago)}
  p.death_date                {|me| DEATH_RATE.rand ? Populator.value_in_range((me.birth_date+10.years)..3.years.ago) : nil}
  p.address_line1             {Faker::Address.street_address}
  p.address_line2             {Faker::Address.secondary_address}
  p.city                      {Faker::Address.city}
  p.state                     {Faker::Address.us_state}
  p.zip                       {Faker::Address.zip_code}
  p.phone                     {Faker::PhoneNumber.phone_number.split(" x")[0]}
  p.work_phone                {Faker::PhoneNumber.phone_number.split(" x")[0]}
  p.work_phone_extension      {Faker::PhoneNumber.phone_number.split(" x")[1]}
end

Factory.sequence :irb_number do |n|
  "STU009999#{"%03d" % n}"
end

Factory.define :protocol do |p|
  p.irb_number            {Factory.next :irb_number}
  p.name                  {"Randomized Evaluation of Sinusitis With Vitamin A"}
  p.title                 {"Randomized Evaluation of Sinusitis With Vitamin A"}
  p.phase                 {"II"}
  p.description           {"Rem fugit culpa unde facilis earum. Quas et vitae ut cumque nihil quidem aperiam architecto. Et asperiores inventore non nisi libero architecto quibusdam.\r\n\r\nVeniam fugiat voluptas laudantium in assumenda. Blanditiis recusandae illum necessitatibus. Quia nesciunt esse officia neque doloribus vel explicabo provident. Non sit vero iusto quibusdam explicabo. Nobis in architecto quam pariatur sit autem optio."}
  p.status                {"Approved"}
  p.reconciliation_date   {3.minutes.ago}
end

Factory.define :fake_protocol, :parent => :protocol do |p|
  # p.irb_number
  p.name                  {Faker::Study.title}
  p.title                 {|me| me.name}
  p.phase                 {["I","II","III","IV","n/a",nil].rand}
  p.description           {Faker::Lorem.paragraphs(3).join("\r\n")}
  p.status                {Faker::Study.eirb_status}
  p.reconciliation_date   {Populator.value_in_range(2.days.ago..2.minutes.ago)}
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
  i.association   :protocol
  i.confirmed     {true}
  i.disease_site  {nil}
  i.description   {Faker::Lorem.words(5).join(" ")}
end

Factory.define :subject_event do |p|
  p.association   :subject
  p.association   :protocol
  p.status        {"Screened"}
  p.status_date   {2.weeks.ago}
  p.notes         {"With flying colors"}
end

Factory.define :user_protocol do |u|
  u.association             :user
  u.association             :protocol
  u.role                    {"Coordinator"}
  u.reconciliation_date     {2.hours.ago}
  u.reconciliation_status   {"Reconciled"}
end
