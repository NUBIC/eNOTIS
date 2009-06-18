# A subject flag is a non-temporal data element that can be associated with a patient.
# It caries with it an application level data element (flag code) and a note string 
# for arbitary data about the flag instance
#
# Example usage: 
# A coordinator has just approached a subject about a clinical trial. The subject indicates 
# that they do not want to be asked about particpating in a clinical trial ever again.
#
# Alternate example usage:
# A subject currently enrolled in a trial is not compliant with study procedures (taking 
# medication, showing up for appointments, etc...). A coordinator can flag a patient as
# non-compliant if needed, this flag would be visible by other coordinators in the 
# enotis system and other authorized users.

class SubjectFlag < ActiveRecord::Base
  belongs_to :subject

end
