# This model represents the affiliation a subject can have with a study.
# It holds non-temporal data only. For reporting purposes we capture gender, ethnicity, and race here
#
# For example: Disease site would be found in the Inolvement join record between a subject and study.
# Disease site is a specific piece of data about why the subject is on the trial but not associated with
# a specific event. It is a long term data element that can span the whole relationship of subject and study.

class Involvement < ActiveRecord::Base
	
  # Associations
  belongs_to :subject
	belongs_to :study
  has_many :involvement_events
  has_one :gender_type, :class_name => "Term"
  has_one :ethnicity_type, :class_name => "Term"
  has_many :races

  # Mixins
  has_paper_trail

end






