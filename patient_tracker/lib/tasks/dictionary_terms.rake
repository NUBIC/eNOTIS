# lib/tasks/dictionary_terms.rake
require 'fastercsv'
namespace :dictionary_terms do

  desc 'Import csv data into terms (the table formerly known as dictionary) table'
  task :import => :environment do
    fastercsv_opts = {:headers => :first_row, :return_headers => false, :header_converters => [:downcase, :symbol]}
    file_path = RAILS_ROOT + "/" + ENV["file"]
    result_counts = {}
    
    raise "usage: rake dictionary_terms:import file=[filename relative to RAILS_ROOT] (optional: dry=true)"  unless ENV.include?("file") && File.exists?(file_path)

    FasterCSV.foreach(file_path, fastercsv_opts) do |row|
      if ENV.include?("dry") && ENV["dry"] != "false"
        puts row.to_hash.inspect
        result_counts[row[:category].downcase] ||= 0
        result_counts[row[:category].downcase] += 1
      else
        if blip && DictionaryTerm.create(row.to_hash)
          result_counts[row[:category].downcase] ||= 0
          result_counts[row[:category].downcase] += 1
        end
      end
    end
    puts
    puts "Imported: " + result_counts.map{|k,v| "#{v} #{k.to_s.pluralize}"}.join(", ")
    puts
  end
end

def blip
  print %w(\\ /).rand # print %w(! @ # $ % ^ & * ( ) _ + - = { } [ ] \\ | ; : ' " " ' < > , . / ?).rand  # print (%w(a b c d e f g h i j k l m n o p q r s t u v w x y z) + Array.new(10, " ")).rand
  return true
end