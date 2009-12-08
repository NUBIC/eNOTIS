require 'spec'
require 'spec/rake/spectask'

# Custom spec task to be able to run specs without rebuilding the database
Spec::Rake::SpecTask.new(:hudson_spec) do |t|
  t.spec_opts = ['--options', "\"#{RAILS_ROOT}/spec/spec.opts\""]
  t.spec_files = FileList['spec/**/*_spec.rb']
end


