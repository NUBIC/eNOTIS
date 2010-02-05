# DO NOT MODIFY THIS FILE
module Bundler
 file = File.expand_path(__FILE__)
 dir = File.dirname(file)

  ENV["PATH"]     = "#{dir}/../../../../bin:#{ENV["PATH"]}"
  ENV["RUBYOPT"]  = "-r#{file} #{ENV["RUBYOPT"]}"

  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/stomp-1.1.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/stomp-1.1.3/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/term-ansicolor-1.0.4/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/term-ansicolor-1.0.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/builder-2.1.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/builder-2.1.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/activesupport-2.3.4/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/activesupport-2.3.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/json_pure-1.2.0/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/json_pure-1.2.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/activemessaging-0.6.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/activemessaging-0.6.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/actionmailer-2.3.4/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/actionmailer-2.3.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/populator-0.2.5/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/populator-0.2.5/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ci_reporter-1.6.0/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ci_reporter-1.6.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/linecache-0.43/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/linecache-0.43/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/factory_girl-1.2.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/factory_girl-1.2.3/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/chronic-0.2.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/chronic-0.2.3/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/paperclip-2.1.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/paperclip-2.1.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/net-ssh-2.0.19/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/net-ssh-2.0.19/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/net-scp-1.0.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/net-scp-1.0.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/net-ssh-gateway-1.0.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/net-ssh-gateway-1.0.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/wddx-0.4.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/wddx-0.4.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/archive-tar-minitar-0.5.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/archive-tar-minitar-0.5.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/color-1.4.0/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/color-1.4.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/transaction-simple-1.4.0/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/transaction-simple-1.4.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/pdf-writer-1.1.8/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/pdf-writer-1.1.8/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rack-1.0.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rack-1.0.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rack-test-0.5.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rack-test-0.5.3/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/actionpack-2.3.4/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/actionpack-2.3.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/session-2.4.0/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/session-2.4.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/polyglot-0.2.9/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/polyglot-0.2.9/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/yoon-view_trail-0.3.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/yoon-view_trail-0.3.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ruby-net-ldap-0.0.4/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ruby-net-ldap-0.0.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/libxml-ruby-1.1.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/libxml-ruby-1.1.3/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/libxml-ruby-1.1.3/ext/libxml")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rubytree-0.6.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rubytree-0.6.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rubyforge-2.0.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rubyforge-2.0.3/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/haml-2.2.17/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/haml-2.2.17/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/chriseppstein-compass-0.8.15/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/chriseppstein-compass-0.8.15/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rake-0.8.7/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rake-0.8.7/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/gemcutter-0.3.0/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/gemcutter-0.3.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/hoe-2.5.0/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/hoe-2.5.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rubigen-1.5.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rubigen-1.5.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/airblade-paper_trail-1.1.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/airblade-paper_trail-1.1.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/activeresource-2.3.4/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/activeresource-2.3.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/diff-lcs-1.1.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/diff-lcs-1.1.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rspec-1.3.0/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rspec-1.3.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/aasm-2.1.4/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/aasm-2.1.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rspec-rails-1.3.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rspec-rails-1.3.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/net-sftp-2.0.4/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/net-sftp-2.0.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/nokogiri-1.4.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/nokogiri-1.4.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/nokogiri-1.4.1/ext")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/webrat-0.7.0/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/webrat-0.7.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/treetop-1.4.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/treetop-1.4.3/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/cucumber-0.3.11/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/cucumber-0.3.11/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/columnize-0.3.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/columnize-0.3.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ruby-debug-base-0.10.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ruby-debug-base-0.10.3/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/activerecord-2.3.4/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/activerecord-2.3.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/binarylogic-searchlogic-2.1.7/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/binarylogic-searchlogic-2.1.7/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/composite_primary_keys-2.3.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/composite_primary_keys-2.3.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/bcsec-1.4.8/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/bcsec-1.4.8/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rails-2.3.4/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rails-2.3.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/httpclient-2.1.5.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/httpclient-2.1.5.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/soap4r-1.5.8/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/soap4r-1.5.8/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/highline-1.5.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/highline-1.5.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/capistrano-2.5.14/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/capistrano-2.5.14/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/bcdatabase-0.6.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/bcdatabase-0.6.3/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/acts_as_reportable-1.1.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/acts_as_reportable-1.1.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/fastercsv-1.5.0/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/fastercsv-1.5.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ruport-1.6.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ruport-1.6.3/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/faker-0.3.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/faker-0.3.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ruby-debug-0.10.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ruby-debug-0.10.3/cli")

  @gemfile = "#{dir}/../../../../Gemfile"

  require "rubygems" unless respond_to?(:gem) # 1.9 already has RubyGems loaded

  @bundled_specs = {}
  @bundled_specs["stomp"] = eval(File.read("#{dir}/specifications/stomp-1.1.3.gemspec"))
  @bundled_specs["stomp"].loaded_from = "#{dir}/specifications/stomp-1.1.3.gemspec"
  @bundled_specs["term-ansicolor"] = eval(File.read("#{dir}/specifications/term-ansicolor-1.0.4.gemspec"))
  @bundled_specs["term-ansicolor"].loaded_from = "#{dir}/specifications/term-ansicolor-1.0.4.gemspec"
  @bundled_specs["builder"] = eval(File.read("#{dir}/specifications/builder-2.1.2.gemspec"))
  @bundled_specs["builder"].loaded_from = "#{dir}/specifications/builder-2.1.2.gemspec"
  @bundled_specs["activesupport"] = eval(File.read("#{dir}/specifications/activesupport-2.3.4.gemspec"))
  @bundled_specs["activesupport"].loaded_from = "#{dir}/specifications/activesupport-2.3.4.gemspec"
  @bundled_specs["json_pure"] = eval(File.read("#{dir}/specifications/json_pure-1.2.0.gemspec"))
  @bundled_specs["json_pure"].loaded_from = "#{dir}/specifications/json_pure-1.2.0.gemspec"
  @bundled_specs["activemessaging"] = eval(File.read("#{dir}/specifications/activemessaging-0.6.1.gemspec"))
  @bundled_specs["activemessaging"].loaded_from = "#{dir}/specifications/activemessaging-0.6.1.gemspec"
  @bundled_specs["actionmailer"] = eval(File.read("#{dir}/specifications/actionmailer-2.3.4.gemspec"))
  @bundled_specs["actionmailer"].loaded_from = "#{dir}/specifications/actionmailer-2.3.4.gemspec"
  @bundled_specs["populator"] = eval(File.read("#{dir}/specifications/populator-0.2.5.gemspec"))
  @bundled_specs["populator"].loaded_from = "#{dir}/specifications/populator-0.2.5.gemspec"
  @bundled_specs["ci_reporter"] = eval(File.read("#{dir}/specifications/ci_reporter-1.6.0.gemspec"))
  @bundled_specs["ci_reporter"].loaded_from = "#{dir}/specifications/ci_reporter-1.6.0.gemspec"
  @bundled_specs["linecache"] = eval(File.read("#{dir}/specifications/linecache-0.43.gemspec"))
  @bundled_specs["linecache"].loaded_from = "#{dir}/specifications/linecache-0.43.gemspec"
  @bundled_specs["factory_girl"] = eval(File.read("#{dir}/specifications/factory_girl-1.2.3.gemspec"))
  @bundled_specs["factory_girl"].loaded_from = "#{dir}/specifications/factory_girl-1.2.3.gemspec"
  @bundled_specs["chronic"] = eval(File.read("#{dir}/specifications/chronic-0.2.3.gemspec"))
  @bundled_specs["chronic"].loaded_from = "#{dir}/specifications/chronic-0.2.3.gemspec"
  @bundled_specs["paperclip"] = eval(File.read("#{dir}/specifications/paperclip-2.1.2.gemspec"))
  @bundled_specs["paperclip"].loaded_from = "#{dir}/specifications/paperclip-2.1.2.gemspec"
  @bundled_specs["net-ssh"] = eval(File.read("#{dir}/specifications/net-ssh-2.0.19.gemspec"))
  @bundled_specs["net-ssh"].loaded_from = "#{dir}/specifications/net-ssh-2.0.19.gemspec"
  @bundled_specs["net-scp"] = eval(File.read("#{dir}/specifications/net-scp-1.0.2.gemspec"))
  @bundled_specs["net-scp"].loaded_from = "#{dir}/specifications/net-scp-1.0.2.gemspec"
  @bundled_specs["net-ssh-gateway"] = eval(File.read("#{dir}/specifications/net-ssh-gateway-1.0.1.gemspec"))
  @bundled_specs["net-ssh-gateway"].loaded_from = "#{dir}/specifications/net-ssh-gateway-1.0.1.gemspec"
  @bundled_specs["wddx"] = eval(File.read("#{dir}/specifications/wddx-0.4.1.gemspec"))
  @bundled_specs["wddx"].loaded_from = "#{dir}/specifications/wddx-0.4.1.gemspec"
  @bundled_specs["archive-tar-minitar"] = eval(File.read("#{dir}/specifications/archive-tar-minitar-0.5.2.gemspec"))
  @bundled_specs["archive-tar-minitar"].loaded_from = "#{dir}/specifications/archive-tar-minitar-0.5.2.gemspec"
  @bundled_specs["color"] = eval(File.read("#{dir}/specifications/color-1.4.0.gemspec"))
  @bundled_specs["color"].loaded_from = "#{dir}/specifications/color-1.4.0.gemspec"
  @bundled_specs["transaction-simple"] = eval(File.read("#{dir}/specifications/transaction-simple-1.4.0.gemspec"))
  @bundled_specs["transaction-simple"].loaded_from = "#{dir}/specifications/transaction-simple-1.4.0.gemspec"
  @bundled_specs["pdf-writer"] = eval(File.read("#{dir}/specifications/pdf-writer-1.1.8.gemspec"))
  @bundled_specs["pdf-writer"].loaded_from = "#{dir}/specifications/pdf-writer-1.1.8.gemspec"
  @bundled_specs["rack"] = eval(File.read("#{dir}/specifications/rack-1.0.1.gemspec"))
  @bundled_specs["rack"].loaded_from = "#{dir}/specifications/rack-1.0.1.gemspec"
  @bundled_specs["rack-test"] = eval(File.read("#{dir}/specifications/rack-test-0.5.3.gemspec"))
  @bundled_specs["rack-test"].loaded_from = "#{dir}/specifications/rack-test-0.5.3.gemspec"
  @bundled_specs["actionpack"] = eval(File.read("#{dir}/specifications/actionpack-2.3.4.gemspec"))
  @bundled_specs["actionpack"].loaded_from = "#{dir}/specifications/actionpack-2.3.4.gemspec"
  @bundled_specs["session"] = eval(File.read("#{dir}/specifications/session-2.4.0.gemspec"))
  @bundled_specs["session"].loaded_from = "#{dir}/specifications/session-2.4.0.gemspec"
  @bundled_specs["polyglot"] = eval(File.read("#{dir}/specifications/polyglot-0.2.9.gemspec"))
  @bundled_specs["polyglot"].loaded_from = "#{dir}/specifications/polyglot-0.2.9.gemspec"
  @bundled_specs["yoon-view_trail"] = eval(File.read("#{dir}/specifications/yoon-view_trail-0.3.1.gemspec"))
  @bundled_specs["yoon-view_trail"].loaded_from = "#{dir}/specifications/yoon-view_trail-0.3.1.gemspec"
  @bundled_specs["ruby-net-ldap"] = eval(File.read("#{dir}/specifications/ruby-net-ldap-0.0.4.gemspec"))
  @bundled_specs["ruby-net-ldap"].loaded_from = "#{dir}/specifications/ruby-net-ldap-0.0.4.gemspec"
  @bundled_specs["libxml-ruby"] = eval(File.read("#{dir}/specifications/libxml-ruby-1.1.3.gemspec"))
  @bundled_specs["libxml-ruby"].loaded_from = "#{dir}/specifications/libxml-ruby-1.1.3.gemspec"
  @bundled_specs["rubytree"] = eval(File.read("#{dir}/specifications/rubytree-0.6.1.gemspec"))
  @bundled_specs["rubytree"].loaded_from = "#{dir}/specifications/rubytree-0.6.1.gemspec"
  @bundled_specs["rubyforge"] = eval(File.read("#{dir}/specifications/rubyforge-2.0.3.gemspec"))
  @bundled_specs["rubyforge"].loaded_from = "#{dir}/specifications/rubyforge-2.0.3.gemspec"
  @bundled_specs["haml"] = eval(File.read("#{dir}/specifications/haml-2.2.17.gemspec"))
  @bundled_specs["haml"].loaded_from = "#{dir}/specifications/haml-2.2.17.gemspec"
  @bundled_specs["chriseppstein-compass"] = eval(File.read("#{dir}/specifications/chriseppstein-compass-0.8.15.gemspec"))
  @bundled_specs["chriseppstein-compass"].loaded_from = "#{dir}/specifications/chriseppstein-compass-0.8.15.gemspec"
  @bundled_specs["rake"] = eval(File.read("#{dir}/specifications/rake-0.8.7.gemspec"))
  @bundled_specs["rake"].loaded_from = "#{dir}/specifications/rake-0.8.7.gemspec"
  @bundled_specs["gemcutter"] = eval(File.read("#{dir}/specifications/gemcutter-0.3.0.gemspec"))
  @bundled_specs["gemcutter"].loaded_from = "#{dir}/specifications/gemcutter-0.3.0.gemspec"
  @bundled_specs["hoe"] = eval(File.read("#{dir}/specifications/hoe-2.5.0.gemspec"))
  @bundled_specs["hoe"].loaded_from = "#{dir}/specifications/hoe-2.5.0.gemspec"
  @bundled_specs["rubigen"] = eval(File.read("#{dir}/specifications/rubigen-1.5.2.gemspec"))
  @bundled_specs["rubigen"].loaded_from = "#{dir}/specifications/rubigen-1.5.2.gemspec"
  @bundled_specs["airblade-paper_trail"] = eval(File.read("#{dir}/specifications/airblade-paper_trail-1.1.1.gemspec"))
  @bundled_specs["airblade-paper_trail"].loaded_from = "#{dir}/specifications/airblade-paper_trail-1.1.1.gemspec"
  @bundled_specs["activeresource"] = eval(File.read("#{dir}/specifications/activeresource-2.3.4.gemspec"))
  @bundled_specs["activeresource"].loaded_from = "#{dir}/specifications/activeresource-2.3.4.gemspec"
  @bundled_specs["diff-lcs"] = eval(File.read("#{dir}/specifications/diff-lcs-1.1.2.gemspec"))
  @bundled_specs["diff-lcs"].loaded_from = "#{dir}/specifications/diff-lcs-1.1.2.gemspec"
  @bundled_specs["rspec"] = eval(File.read("#{dir}/specifications/rspec-1.3.0.gemspec"))
  @bundled_specs["rspec"].loaded_from = "#{dir}/specifications/rspec-1.3.0.gemspec"
  @bundled_specs["aasm"] = eval(File.read("#{dir}/specifications/aasm-2.1.4.gemspec"))
  @bundled_specs["aasm"].loaded_from = "#{dir}/specifications/aasm-2.1.4.gemspec"
  @bundled_specs["rspec-rails"] = eval(File.read("#{dir}/specifications/rspec-rails-1.3.2.gemspec"))
  @bundled_specs["rspec-rails"].loaded_from = "#{dir}/specifications/rspec-rails-1.3.2.gemspec"
  @bundled_specs["net-sftp"] = eval(File.read("#{dir}/specifications/net-sftp-2.0.4.gemspec"))
  @bundled_specs["net-sftp"].loaded_from = "#{dir}/specifications/net-sftp-2.0.4.gemspec"
  @bundled_specs["nokogiri"] = eval(File.read("#{dir}/specifications/nokogiri-1.4.1.gemspec"))
  @bundled_specs["nokogiri"].loaded_from = "#{dir}/specifications/nokogiri-1.4.1.gemspec"
  @bundled_specs["webrat"] = eval(File.read("#{dir}/specifications/webrat-0.7.0.gemspec"))
  @bundled_specs["webrat"].loaded_from = "#{dir}/specifications/webrat-0.7.0.gemspec"
  @bundled_specs["treetop"] = eval(File.read("#{dir}/specifications/treetop-1.4.3.gemspec"))
  @bundled_specs["treetop"].loaded_from = "#{dir}/specifications/treetop-1.4.3.gemspec"
  @bundled_specs["cucumber"] = eval(File.read("#{dir}/specifications/cucumber-0.3.11.gemspec"))
  @bundled_specs["cucumber"].loaded_from = "#{dir}/specifications/cucumber-0.3.11.gemspec"
  @bundled_specs["columnize"] = eval(File.read("#{dir}/specifications/columnize-0.3.1.gemspec"))
  @bundled_specs["columnize"].loaded_from = "#{dir}/specifications/columnize-0.3.1.gemspec"
  @bundled_specs["ruby-debug-base"] = eval(File.read("#{dir}/specifications/ruby-debug-base-0.10.3.gemspec"))
  @bundled_specs["ruby-debug-base"].loaded_from = "#{dir}/specifications/ruby-debug-base-0.10.3.gemspec"
  @bundled_specs["activerecord"] = eval(File.read("#{dir}/specifications/activerecord-2.3.4.gemspec"))
  @bundled_specs["activerecord"].loaded_from = "#{dir}/specifications/activerecord-2.3.4.gemspec"
  @bundled_specs["binarylogic-searchlogic"] = eval(File.read("#{dir}/specifications/binarylogic-searchlogic-2.1.7.gemspec"))
  @bundled_specs["binarylogic-searchlogic"].loaded_from = "#{dir}/specifications/binarylogic-searchlogic-2.1.7.gemspec"
  @bundled_specs["composite_primary_keys"] = eval(File.read("#{dir}/specifications/composite_primary_keys-2.3.2.gemspec"))
  @bundled_specs["composite_primary_keys"].loaded_from = "#{dir}/specifications/composite_primary_keys-2.3.2.gemspec"
  @bundled_specs["bcsec"] = eval(File.read("#{dir}/specifications/bcsec-1.4.8.gemspec"))
  @bundled_specs["bcsec"].loaded_from = "#{dir}/specifications/bcsec-1.4.8.gemspec"
  @bundled_specs["rails"] = eval(File.read("#{dir}/specifications/rails-2.3.4.gemspec"))
  @bundled_specs["rails"].loaded_from = "#{dir}/specifications/rails-2.3.4.gemspec"
  @bundled_specs["httpclient"] = eval(File.read("#{dir}/specifications/httpclient-2.1.5.2.gemspec"))
  @bundled_specs["httpclient"].loaded_from = "#{dir}/specifications/httpclient-2.1.5.2.gemspec"
  @bundled_specs["soap4r"] = eval(File.read("#{dir}/specifications/soap4r-1.5.8.gemspec"))
  @bundled_specs["soap4r"].loaded_from = "#{dir}/specifications/soap4r-1.5.8.gemspec"
  @bundled_specs["highline"] = eval(File.read("#{dir}/specifications/highline-1.5.1.gemspec"))
  @bundled_specs["highline"].loaded_from = "#{dir}/specifications/highline-1.5.1.gemspec"
  @bundled_specs["capistrano"] = eval(File.read("#{dir}/specifications/capistrano-2.5.14.gemspec"))
  @bundled_specs["capistrano"].loaded_from = "#{dir}/specifications/capistrano-2.5.14.gemspec"
  @bundled_specs["bcdatabase"] = eval(File.read("#{dir}/specifications/bcdatabase-0.6.3.gemspec"))
  @bundled_specs["bcdatabase"].loaded_from = "#{dir}/specifications/bcdatabase-0.6.3.gemspec"
  @bundled_specs["acts_as_reportable"] = eval(File.read("#{dir}/specifications/acts_as_reportable-1.1.1.gemspec"))
  @bundled_specs["acts_as_reportable"].loaded_from = "#{dir}/specifications/acts_as_reportable-1.1.1.gemspec"
  @bundled_specs["fastercsv"] = eval(File.read("#{dir}/specifications/fastercsv-1.5.0.gemspec"))
  @bundled_specs["fastercsv"].loaded_from = "#{dir}/specifications/fastercsv-1.5.0.gemspec"
  @bundled_specs["ruport"] = eval(File.read("#{dir}/specifications/ruport-1.6.3.gemspec"))
  @bundled_specs["ruport"].loaded_from = "#{dir}/specifications/ruport-1.6.3.gemspec"
  @bundled_specs["faker"] = eval(File.read("#{dir}/specifications/faker-0.3.1.gemspec"))
  @bundled_specs["faker"].loaded_from = "#{dir}/specifications/faker-0.3.1.gemspec"
  @bundled_specs["ruby-debug"] = eval(File.read("#{dir}/specifications/ruby-debug-0.10.3.gemspec"))
  @bundled_specs["ruby-debug"].loaded_from = "#{dir}/specifications/ruby-debug-0.10.3.gemspec"

  def self.add_specs_to_loaded_specs
    Gem.loaded_specs.merge! @bundled_specs
  end

  def self.add_specs_to_index
    @bundled_specs.each do |name, spec|
      Gem.source_index.add_spec spec
    end
  end

  add_specs_to_loaded_specs
  add_specs_to_index

  def self.require_env(env = nil)
    context = Class.new do
      def initialize(env) @env = env && env.to_s ; end
      def method_missing(*) ; yield if block_given? ; end
      def only(*env)
        old, @only = @only, _combine_only(env.flatten)
        yield
        @only = old
      end
      def except(*env)
        old, @except = @except, _combine_except(env.flatten)
        yield
        @except = old
      end
      def gem(name, *args)
        opt = args.last.is_a?(Hash) ? args.pop : {}
        only = _combine_only(opt[:only] || opt["only"])
        except = _combine_except(opt[:except] || opt["except"])
        files = opt[:require_as] || opt["require_as"] || name
        files = [files] unless files.respond_to?(:each)

        return unless !only || only.any? {|e| e == @env }
        return if except && except.any? {|e| e == @env }

        if files = opt[:require_as] || opt["require_as"]
          files = Array(files)
          files.each { |f| require f }
        else
          begin
            require name
          rescue LoadError
            # Do nothing
          end
        end
        yield if block_given?
        true
      end
      private
      def _combine_only(only)
        return @only unless only
        only = [only].flatten.compact.uniq.map { |o| o.to_s }
        only &= @only if @only
        only
      end
      def _combine_except(except)
        return @except unless except
        except = [except].flatten.compact.uniq.map { |o| o.to_s }
        except |= @except if @except
        except
      end
    end
    context.new(env && env.to_s).instance_eval(File.read(@gemfile), @gemfile, 1)
  end
end

module Gem
  @loaded_stacks = Hash.new { |h,k| h[k] = [] }

  def source_index.refresh!
    super
    Bundler.add_specs_to_index
  end
end
