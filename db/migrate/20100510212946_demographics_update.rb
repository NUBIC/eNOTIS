class DemographicsUpdate < ActiveRecord::Migration
    RDEFS = Involvement::RACE_ATTRIBUTES
  
  def self.up
    puts "Beginning data migration and db change"
    puts "-====================================-"

    # Adding the new columns as defined in the class
    puts "Adding new fields:"
    RDEFS.each_key do |r_key|    
      puts "adding #{r_key}"
      add_column(:involvements, r_key, :boolean, :default => false)
    end

    Involvement.find(:all).each do |inv|
      if RDEFS.values.include?(inv.race)
        puts "moving race #{inv.race} on Involvement ID#{inv.id}"
        inv.races = inv.race
        inv.save
      end
    end
    
    # double check
    Involvement.find(:all).each do |inv|
      if inv.race != inv.races.first
        raise "!!! Data move error on #{inv.inspect}"
      else
        puts "Data move OKAY for Involvment ID#{inv.id}"
      end
    end
    
    puts "Removing race column"
    remove_column(:involvements, :race)
  end

  def self.down
    puts "Rolling data migration and db change"
    puts "-===================================-"

    puts "Adding back old race column"
    add_column(:involvements, :race, :string)
    
    Involvement.find(:all).each do |inv|
      puts "mapping back #{inv.races.first} for #{inv.id}"
      inv.race = inv.races.first
      inv.save
    end

    # Removing the columns we added previously
    puts "Removing the columns added:"
    RDEFS.each_key do |r_key|    
      puts "removing #{r_key} column"
      remove_column(:involvements, r_key)
    end
  end
end
