# A subject data is a non-temporal element that can be associated with a patient.
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

class SubjectData < ClinicalData
  belongs_to :subject
  
end
