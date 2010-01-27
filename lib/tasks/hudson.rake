if ENV["RAILS_ENV"] == "hudson"
  require 'spec/rake/spectask'
  require 'cucumber/rake/task'
  require 'ci/reporter/rake/rspec'

  namespace :hudson do
    ENV["CI_REPORTS"] = "reports/spec-xml"

    desc "Execute the CI build"
    task :all => [:"log:clear", :"db:migrate", :spec, :cucumber]

    desc "Execute the spec suite without setting up the database and with ci_reporter enabled"
    Spec::Rake::SpecTask.new(:spec => [:"ci:setup:rspec"]) do |t|
      t.spec_opts = ['--options', "\"#{RAILS_ROOT}/spec/spec.opts\""]
      t.spec_files = FileList['spec/**/*_spec.rb']
    end

    desc "Execute cucumber features that should pass without setting up the database"
    Cucumber::Rake::Task.new(:cucumber) do |t|
      t.fork = true
      t.profile = 'hudson'
    end
  end
end
