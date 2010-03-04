# lib/tasks/couch.rake
desc 'Connects, updates studies, updates coordinators'
task :couch => :"couch:default"

namespace :couch do
  task :default => [:"couch:connect", :"couch:studies", :"couch:coordinators"]

  desc 'Connects to couchDB'
  task :connect => :environment do
    puts "Connecting..."
    Study.cache_connect
    puts
  end

  desc 'Updates studies'
  task :studies => :connect do
    puts "Studies..."
    Study.update_all_from_cache
    puts "  Studies complete"
  end

  desc 'Updates coordinators'
  task :coordinators => :connect do
    puts "Coordinators..."
    Study.update_coordinators_from_cache
    puts "  Coordinators complete"
  end
end

