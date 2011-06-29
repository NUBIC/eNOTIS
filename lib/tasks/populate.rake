# lib/tasks/populate.rake
namespace :db do

  desc 'Remigrates, sets up test db, and populates'
  task :bootstrap => [:environment, :"migrate:reset", :"test:prepare", :"populate:default"]

  desc 'Populates database with fake data'
  task :populate => :"populate:default"

  namespace :populate do

    task :default => [:environment, :clear_db,
      :admins, :roles_and_studies, :roles,
      :involvements_and_subjects
    ]

    desc 'Clear models: Roles, Study, Involvement, Subject, InvolvementEvent'
    task :clear_db => :environment do
      puts
      puts "clearing db..."
      [Role, InvolvementEvent, Involvement, Study, Subject].each(&:delete_all)
    end

    desc 'Populate admins'
    task :admins => [:environment, :"users:create_admins"] do
      puts "creating admins..."
    end

    desc 'Populate roles: joins users(random) and studies(fake)'
    task :roles_and_studies => :environment do
      puts "creating roles and studies..."
      80.times do |i|
        blip
        Factory.create(:role_accrues, :study => Factory.create(:fake_study), :netid => random_netid)
      end
      puts
    end

    desc 'Populate roles: joins users(random) and studies(random)'
    task :roles => :environment do
      puts "creating extra roles..."
      50.times do |i|
        begin
          blip && Factory.create(:role_accrues, :study => random(Study), :netid => random_netid)
        rescue
        end
      end
      puts
    end

    desc 'Populate one role: joins user(given) and studies(random)'
    task :roles => :environment do
      puts "creating extra accrual role for #{ENV['NETID']}..."
      10.times do |i|
        begin
          blip && Factory.create(:role_accrues, :study => random(Study), :netid => ENV['NETID'])
        rescue
        end
      end
      puts
    end

    desc 'Populate involvements: joins subjects(fake) and studies(random)'
    task :involvements_and_subjects => :environment do
      puts "creating involvements and subjects..."
      3000.times do |i|
        blip
        study = random(Study)
        # weight this more heavily towards consent event types
        type_candidates = study.event_types +
          (study.event_types.select { |et| et.name == 'Consented' } * 20)
        involvement = Factory.create(
          :involvement, :study => study, :subject => Factory.create(:fake_subject),
          :gender => Involvement.genders.rand, :ethnicity => Involvement.ethnicities.rand,
          :race => Involvement.races.rand
          )
        Factory.create(
          :involvement_event, :event_type => type_candidates.rand, :involvement => involvement
          )
      end
      puts
    end

    desc 'Add COUNT involvements to a STUDY'
    task :involvements_for_study => :environment do
      study = if ENV['STUDY']
                Study.find_by_irb_number(ENV['STUDY'])
              else
                Study.first
              end
      fail "Study not found" unless study
      count = ENV['COUNT'].nil? ? 1000 : ENV['COUNT'].to_i
      $stderr.puts "Adding #{count} involvements to #{study.name.inspect} (#{study.irb_number})"
      consented = study.event_types.detect { |et| et.name == 'Consented' } or
        fail "No consented type for #{study.irb_number}"
      count.times do
        blip
        involvement = Factory.create(
          :involvement, :study => study, :subject => Factory.create(:fake_subject),
          :gender => Involvement.genders.rand, :ethnicity => Involvement.ethnicities.rand,
          :race => Involvement.races.rand
          )
        Factory.create(
          :involvement_event, :event_type => consented, :involvement => involvement
          )
      end
    end

    desc 'Spit out random netids'
    task :sample_netids => :environment do
      puts "here are some netids..."
      10.times { |i| puts random_netid}
      puts
    end

    desc 'Populate VIP roles manually. Does not set accrual flag'
    task :vip => :environment do
      while !(pair = ask("netid, irb_number: ")).blank? do
        netid, irb_number = pair.split(",", 2).map(&:strip)
        coord = Role.create(:netid => netid, :study => Study.find_by_irb_number(irb_number))
        puts coord.save ? coord.inspect : coord.all_errors
      end
    end
  end
end

# Helper methods
def random(model)#, options={})
  #ids = model.find(:all, :select => "id", :conditions => options[:conditions])
  ids = ActiveRecord::Base.connection.select_all("SELECT id FROM #{model.to_s.tableize}")
  model.find(ids[rand(ids.length)]["id"].to_i) unless ids.blank?
end
def random_netid
  @netids ||= []
  if @netids.empty?
    l = ('a'..'z').to_a
    n = (0..9).to_a
    @netids = 20.times.
      map { |x| "#{l[rand(26)]}#{l[rand(26)]}#{l[rand(26)]}#{n[rand(9)]}#{n[rand(9)]}#{n[rand(9)]}" } +
      %w(blc615 daw286 lmw351 myo628 wakibbe)
  end
  @netids[rand(20)]
end
def blip
  $stderr.print %w(\\ /).rand
  $stderr.flush
  return true
end
def ask(message)
  print message
  STDIN.gets.chomp
end
