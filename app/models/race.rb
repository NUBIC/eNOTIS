# Holds the OMB defined race category for a study involvement
# A person on one study can (theoretically) have a different race on a different study

class Race < ActiveRecord::Base

  # Associations
  belongs_to :involvement
  belongs_to :race_type, :class_name => "DictionaryTerm", :foreign_key => :race_type_id

  #validators
  validates_presence_of :race_type_id

  # Mixins
  has_paper_trail
  
  def short_race_type
    race_type.term[0..12]
  end
  
end
