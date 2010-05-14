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
      old_race = Involvement.find_by_sql("select involvements.race from involvements where involvements.id = #{inv.id}").first[:race]
      if RDEFS.values.include?(old_race)
        puts "moving race #{old_race} on Involvement ID#{inv.id}"
        inv.race = old_race
        inv.save
      end
    end
    
    # double check
    Involvement.find(:all).each do |inv|
      old_race = Involvement.find_by_sql("select involvements.race from involvements where involvements.id = #{inv.id}").first[:race]      
      if inv.race.first != old_race and RDEFS.values.include?(old_race)
        raise "!!! Data move error on #{inv.inspect} - Old race '#{old_race}' Set Race '#{inv.race}'"
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
