# lib/tasks/dictionary_terms.rake
require 'fastercsv' if defined? FasterCSV
namespace :dictionary_terms do

  desc 'Import csv data into terms (the table formerly known as dictionary) table. Imports doc/terms.csv by default, or specify using file=path/to/file'
  task :import => :environment do
    fastercsv_opts = {:headers => :first_row, :return_headers => false, :header_converters => [:downcase, :symbol]}
    file_path = RAILS_ROOT + "/" + (ENV["file"] || "doc/terms.csv")
    update_counts = {}
    create_counts = {}
    raise "usage: rake dictionary_terms:import file=[filename relative to RAILS_ROOT] (optional: dry_run=true)"  unless File.exists?(file_path)
    
    puts
    puts "importing #{file_path}..."
    puts
        
    FasterCSV.foreach(file_path, fastercsv_opts) do |row|
      if ENV.include?("dry_run") && ENV["dry_run"] != "false"
        puts row.to_hash.inspect
        if dt = DictionaryTerm.find_by_category_and_term(row[:category].downcase, row[:term].downcase)
          update_counts[row[:category].downcase] ||= 0
          update_counts[row[:category].downcase] += 1        
        else
          create_counts[row[:category].downcase] ||= 0
          create_counts[row[:category].downcase] += 1
        end
      else
        blip
        if dt = DictionaryTerm.find_by_category_and_term(row[:category].downcase, row[:term].downcase)
          dt.update_attributes(row.to_hash)
          update_counts[row[:category].downcase] ||= 0
          update_counts[row[:category].downcase] += 1
        elsif DictionaryTerm.create(row.to_hash)
          create_counts[row[:category].downcase] ||= 0
          create_counts[row[:category].downcase] += 1
        end
      end
    end
    puts
    puts "updated: " + update_counts.map{|k,v| "#{v} #{k.to_s.pluralize}"}.join(", ")
    puts "created: " + create_counts.map{|k,v| "#{v} #{k.to_s.pluralize}"}.join(", ")

    puts
  end
end

def blip
  print %w(\\ /).rand # print %w(! @ # $ % ^ & * ( ) _ + - = { } [ ] \\ | ; : ' " " ' < > , . / ?).rand  # print (%w(a b c d e f g h i j k l m n o p q r s t u v w x y z) + Array.new(10, " ")).rand
  return true
end