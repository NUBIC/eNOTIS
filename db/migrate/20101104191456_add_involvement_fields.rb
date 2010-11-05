class AddInvolvementFields < ActiveRecord::Migration
  def self.up
    add_column :involvements, :address_line1, :string
    add_column :involvements, :address_line2, :string   
    add_column :involvements, :city, :string
    add_column :involvements, :state, :string   
    add_column :involvements, :zip, :string
    add_column :involvements, :email, :string   
    add_column :involvements, :home_phone, :string
    add_column :involvements, :work_phone, :string   
    add_column :involvements, :cell_phone, :string
    add_column :subjects, :nmff_mrn, :string
    add_column :subjects, :nmh_mrn, :string
    
    puts "Processing Subject MRNs"
    Subject.all.each do |s|
      unless s.mrn.blank?
        print "."
        case s.mrn_type
        when /NMFF/ then s.update_attributes(:nmff_mrn => s.mrn)
        when /NMH/ then s.update_attributes(:nmh_mrn => s.mrn)
        end
      end
    end
    puts
  end

  def self.down
    puts "Processing Subject MRNs. Data will be lost (preferring NMFF MRNs)"
    Subject.all.each do |s|
      unless s.nmh_mrn.blank? and s.nmff_mrn.blank?
        print "."
        if s.nmff_mrn.blank?
          s.update_attributes(:mrn => s.nmh_mrn, :mrn_type => "NMH")
        else
          s.update_attributes(:mrn => s.nmff_mrn, :mrn_type => "NMFF")
        end
      end
    end
    puts

    remove_column :involvements, :address_line1
    remove_column :involvements, :address_line2   
    remove_column :involvements, :city
    remove_column :involvements, :state   
    remove_column :involvements, :zip
    remove_column :involvements, :email   
    remove_column :involvements, :home_phone
    remove_column :involvements, :work_phone   
    remove_column :involvements, :cell_phone
    remove_column :subjects, :nmff_mrn
    remove_column :subjects, :nmh_mrn
  end
end
