
# setup checks the environment for proper versions of things
puts "checking the environment"
begin
  puts "looking for rubygems"
  if require 'rubygems'
    puts "you have rubygems (version #{(`gem --version`).gsub(/\r|\n/,'')})"
  end
rescue
  puts 'rubygems not installed'
end

# Checking other versions of things
#reqs_str = <<STR
reqs = ["rake --version '0.8.3'",
  "rails --version '2.3.2'",
  "bcdatabase --version '0.5.5'",
  "postgres-pr --version '0.6.1'",
  "ruby-net-ldap --version '0.0.4'",
  "wddx --version '0.4.1'",
  "composite_primary_keys --version '2.2.2'",
  "rspec --version '1.2.4'",
  "rspec-rails --version '1.2.4'",
  "cucumber",
  #"will_paginate --version '2.2.2'", --installed via gemsonrails
  "capistrano --version '2.5.5'",
  "rcov --version '0.8.1.2.0'",
 # "calendar_date_select --version '1.15'", --installed via gemsonrails
  "haml",
  "gemsonrails --version '0.7.2'"
]

#STR

#reqs = YAML::load(reqs_str)
reqs.each do |r|
  puts "looking for #{r}"
  begin
    if require r
      puts "you have #{r}"
    else
      puts "install #{r}"
    end
  rescue LoadError
    puts "#{r} not installed - installing #{r}"
    `sudo gem install #{r} --no-rdoc --no-ri`
  end
end
puts "Run 'rake gems' to check application level depenencies"

