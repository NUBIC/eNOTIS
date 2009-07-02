# lib/tasks/populate.rake
namespace :db do
  task :populate => :environment do
    require 'populator' # http://populator.rubyforge.org/
    require 'faker' # http://faker.rubyforge.org/rdoc/
    require 'spec/factories'
  
    puts "\nclearing db..."
    [User, Coordinator, Study, Involvement, Subject, InvolvementEvent].each(&:delete_all)
    # Rake::Task['db:fixtures:load'].invoke

    def random(model)
      ids = ActiveRecord::Base.connection.select_all("SELECT id FROM #{model.to_s.tableize}")
      model.find(ids[rand(ids.length)]["id"].to_i) unless ids.blank?
    end
    def blip
      # print %w(! @ # $ % ^ & * ( ) _ + - = { } [ ] \\ | ; : ' " " ' < > , . / ?).rand
      # print (%w(a b c d e f g h i j k l m n o p q r s t u v w x y z) + Array.new(10, " ")).rand
      print %w(\\ /).rand
    end
    def bump
      puts
    end
    
    puts "creating admins..."
    Factory.create(:fake_user, :first_name => "Reginal", :last_name => "Campbell", :netid => "rkc226")
    Factory.create(:fake_user, :first_name => "Brian", :last_name => "Chamberlain", :netid => "blc615")
    Factory.create(:fake_user, :first_name => "David", :last_name => "Were", :netid => "daw286")
    Factory.create(:fake_user, :first_name => "Mark", :last_name => "Yoon", :netid => "myo628")
        
    puts "creating users..."
    30.times { |i|
      Factory.create(:fake_user)
      # User.create(:login => Faker::Lorem.words(1).to_s, :email => Faker::Internet.email, :password => 'monkey')
      blip
    }
    bump
    puts "creating coordinators and studies..."
    200.times { |i|
      Factory.create(:coordinator, :study => Factory.create(:fake_study), :user => random(User))
      blip
    }
    bump
    puts "creating extra coordinators..."
    50.times { |i|
      Factory.create(:coordinator, :study => random(Study), :user => random(User))
      blip
    }
    bump
    puts "creating involvements and subjects..."
    500.times { |i|
      i = Factory.create(:involvement, :study => random(Study), :subject => Factory.create(:fake_subject))
      Factory.create(:involvement_event, :involvement => i)
      blip
    }
    bump
    puts "creating extra involvements..."
    200.times { |i|
      i = Factory.create(:involvement, :study => random(Study), :subject => random(Subject))
      Factory.create(:involvement_event, :involvement => i)
      blip
    }
    bump
    
    puts "here are some netids..."
    10.times { |i|
      puts random(User).netid
    }
    bump
    # puts 'creating posts...'
    # 40.times { |i|
    #   random(User).posts.create(:body => Faker::Lorem.words, :created_at => Populator.value_in_range(10.years.ago..Time.now).to_s)
    # }    
 
  end
end
