require 'populator'
require 'faker'

LOST_RATE = Array.new(99, false) + Array.new(1, true) # 1 in 100
DEATH_RATE = Array.new(195, false) + Array.new(5, true) # 5 in 200

# This will guess the Patient class
Factory.sequence :mrn do |n|
  "#{n+9988100}"
end

Factory.define :patient do |u|
  u.mrn                       {Factory.next :mrn}
  u.mrn_type                  {"Cerner"}
  u.source                    {"EDW"}
  u.last_reconciled           {3.minutes.ago}
  u.reconcile_status          {nil}
  u.first_name                {"Pi"}
  u.last_name                 {"Patel"}
  u.lost_to_follow_up         {false}
  u.lost_to_follow_up_reason  {nil}
  u.birth_date                {Date.parse('1941-03-01')} # 3/1/41
  u.death_date                {nil}
  u.address_line1             {"314 Circle Dr."}
  u.address_line2             {"Suite 159"}
  u.city                      {"Garden City"}
  u.state                     {"GA"}
  u.zip                       {"31415"}
  u.phone                     {"110 010 0100"}
  u.work_phone                {"180 180 1801"}
  u.work_phone_extension      {"801"}
end

Factory.define :fake_patient, :parent => :patient do |u|
  u.mrn_type                  {["Epic", "Cerner"].rand}
  u.source                    { (Array.new(10, "EDW") + ["Local"]).rand }
  u.last_reconciled           {Populator.value_in_range(2.days.ago..2.minutes.ago)}
  # u.reconcile_status          nil
  u.first_name                {Faker::Name.first_name}
  u.last_name                 {Faker::Name.last_name}
  u.lost_to_follow_up         {LOST_RATE.rand}
  u.lost_to_follow_up_reason  {|u| u.lost_to_follow_up ? ["oops!", "doh!"].rand : nil }
  u.birth_date                {Populator.value_in_range(80.years.ago..15.years.ago)}
  u.death_date                {|u| DEATH_RATE.rand ? Populator.value_in_range((u.birth_date+10.years)..3.years.ago) : nil}
  u.address_line1             {Faker::Address.street_address}
  u.address_line2             {Faker::Address.secondary_address}
  u.city                      {Faker::Address.city}
  u.state                     {Faker::Address.us_state}
  u.zip                       {Faker::Address.zip_code}
  u.phone                     {Faker::PhoneNumber.phone_number.split(" x")[0]}
  u.work_phone                {Faker::PhoneNumber.phone_number.split(" x")[0]}
  u.work_phone_extension      {Faker::PhoneNumber.phone_number.split(" x")[1]}
end

Factory.sequence :email do |n|
  "person#{n}@northwestern.edu"
end
Factory.define :user do |u|
  u.email { Factory.next :email }
  u.first_name 'Test'
  u.last_name 'User'
end

Factory.define :user_sample, :parent => :user do |u|
  u.first_name { Faker::Name.first_name }
  u.last_name { Faker::Name.last_name }
end
