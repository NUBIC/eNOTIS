# Holds the OMB defined race category for a study involvement
# A person on one study can (theoretically) have a different race on a different study

class Race < ActiveRecord::Base

  # Associations
  belongs_to :involvement
  has_one :race_type, :class_name => "DictionaryTerm" 

  # Mixins
  has_paper_trail

end
