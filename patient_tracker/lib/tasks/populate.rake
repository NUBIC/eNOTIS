# lib/tasks/populate.rake
namespace :db do

  desc 'Populates database with fake data'
  task :populate => :"populate:default"

  namespace :populate do

    task :default => [:environment, :clear_db, :admins, :users, :coordinators_and_studies, :coordinators, :involvements_and_subects, :involvements, :sample_netids]
    
    desc 'Clear models: User, Coordinator, Study, Involvement, Subject, InvolvementEvent'
    task :clear_db => :environment do
      puts
      puts "clearing db..."
      [User, Coordinator, Study, Involvement, Subject, InvolvementEvent].each(&:delete_all)
    end

    desc 'Populate admins(Reggie, Brian, David, Mark)'
    task :admins => [:environment, :"users:create_admins"]

    desc 'Populate users(fake)'
    task :users => :environment do  
      puts "creating users..."
      30.times { |i| blip && Factory.create(:fake_user)}
      puts
    end

    desc 'Populate coordinators: joins users(random) and studies(fake)'
    task :coordinators_and_studies => :environment do      
      puts "creating coordinators and studies..."
      200.times { |i| blip && Factory.create(:coordinator, :study => Factory.create(:fake_study), :user => random(User))}
      puts
    end

    desc 'Populate coordinators: joins users(random) and studies(random)'
    task :coordinators => :environment do
      puts "creating extra coordinators..."
      50.times { |i| blip && Factory.create(:coordinator, :study => random(Study), :user => random(User))}
      puts
    end

    desc 'Populate involvements: joins subjects(fake) and studies(random)'
    task :involvements_and_subects => :environment do
      puts "creating involvements and subjects..."
      500.times { |i| blip && Factory.create(:involvement_event, :involvement => Factory.create(:involvement, :study => random(Study), :subject => Factory.create(:fake_subject)))}
      puts
    end

    desc 'Populate involvements: joins subjects(random) and studies(random)'
    task :involvements => :environment do
      puts "creating extra involvements..."
      200.times { |i| blip && Factory.create(:involvement_event, :involvement => Factory.create(:involvement, :study => random(Study), :subject => random(Subject)))}
      puts
    end

    desc 'Spit out random netids'
    task :sample_netids => :environment do      
      puts "here are some netids..."
      10.times { |i| puts random(User).netid}
      puts
    end 

  end
end

# Helper methods
def random(model)
  ids = ActiveRecord::Base.connection.select_all("SELECT id FROM #{model.to_s.tableize}")
  model.find(ids[rand(ids.length)]["id"].to_i) unless ids.blank?
end
def blip
  print %w(\\ /).rand # print %w(! @ # $ % ^ & * ( ) _ + - = { } [ ] \\ | ; : ' " " ' < > , . / ?).rand  # print (%w(a b c d e f g h i j k l m n o p q r s t u v w x y z) + Array.new(10, " ")).rand
  return true
end