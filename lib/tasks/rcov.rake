# From http://github.com/jaymcgavren
#
# Save this as rcov.rake in lib/tasks and use rcov:all =>
# to get accurate spec/feature coverage data

require 'cucumber/rake/task' if defined? Cucumber
require 'spec/rake/spectask' if defined? Rspec

namespace :rcov do
  if defined? Cucumber
    Cucumber::Rake::Task.new(:cucumber) do |t|    
      t.rcov = true
      t.rcov_opts = %w{--rails --exclude osx\/objc,gems\/,spec\/,features\/ --aggregate coverage.data}
      t.rcov_opts << %[-o "coverage"]
    end
  end
  if defined? Rspec
    Spec::Rake::SpecTask.new(:rspec) do |t|
      t.spec_opts = ['--options', "\"#{RAILS_ROOT}/spec/spec.opts\""]
      t.spec_files = FileList['spec/**/*_spec.rb']
      t.rcov = true
      t.rcov_opts = lambda do
        IO.readlines("#{RAILS_ROOT}/spec/rcov.opts").map {|l| l.chomp.split " "}.flatten
      end
    end
  end
  desc "Run both specs and features to generate aggregated coverage"
  task :all do |t|
    rm "coverage.data" if File.exist?("coverage.data")
    Rake::Task["rcov:cucumber"].invoke
    Rake::Task["spec:rcov"].invoke
  end
end

