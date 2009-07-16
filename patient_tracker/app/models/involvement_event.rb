# This model holds the events that are associated with a subject on
# a study. These would be events that have clinical significance like
# when the subject was consented, screened, withdrawn, etc...

class InvolvementEvent < ActiveRecord::Base

  # Associations
  belongs_to :involvement
  has_one :event_type, :class_name => "Term"
  
  # Mixins
  has_paper_trail

end
