class EventTypeData < ActiveRecord::Migration
  def self.up
    # Add the column to the involvment events for clinical_event parent
    add_column(:involvement_events, :event_type_id, :integer)
    add_index(:involvement_events, :event_type_id)
    
    # Migrate over the current events to point to the new
    # global events (they are stored as string names)
    puts "=========== Migrating InvolvementEvents ============="      
    puts "Getting every study and adding the events and adding links to them"
    
    Study.find(:all).each do |s|
      s.create_default_events
      s.involvements.each do |inv|
        inv.involvement_events.each do |inv_e|
          print "."
          inv_e.event_type = s.event_types.find_by_name(inv_e.event.titleize)
          if inv_e.event_type_id.nil?
            raise "Could not find event for #{inv_e.event} out of #{s.clinical_events.map(&:name).join(',')}" 
          end
          inv_e.save! 
        end
      end
    end
    puts " "

    # Verify data migration
    puts "Verifiying InvolvementEvents:"
    InvolvementEvent.find(:all).each do |ie|
      print "."
      unless ie.event_type.name == ie.event
        raise "Migration verification error on #{ie.inspect}\n #{ie.clinical_event.name} should == #{ie.event}"
      end
    end 
    puts " "

    # Drop column to hold event name, we'll now use the id
    remove_column(:involvement_events, :event)
  end

  # Reverting and recreating the data
  def self.down
    
    # Add the "event" string back to the involvment event 
    add_column(:involvement_events, :event, :string)

    puts "=========== Rolling Back InvolvementEvents ============="      
    puts "Getting every study removing links to their study events, then cleaning up the clinical_events"
    
    Study.find(:all).each do |s|
      print "Study: #{s.irb_number}"
      s.involvements.each do |inv|
        inv.involvement_events.each do |inv_e|
          print "."
          inv_e.event = inv_e.event_type.name
          if inv_e.event.empty?
            raise "Could not find clinical event for #{inv_e.inspect}"
          end
          inv_e.save! 
        end
      end
      puts " "
    end

    # Verify the reverting 
    puts "Verifiying Reversal of InvolvementEvents:"
    InvolvementEvent.find(:all).each do |ie|
      print "."
      unless ie.event == ie.event_type.name
        raise "Reverse migration verification error on #{ie.inspect}"
      end
    end
    puts " "

    # Drop the column for clinical_event
    remove_index(:involvement_events, :event_type_id)
    remove_column(:involvement_events, :event_type_id)
  end
end
