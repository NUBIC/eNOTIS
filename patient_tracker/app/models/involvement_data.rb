# InvolvementData holds data around the subjects' involvment with a trial.
# This includes the subjects gender, race, ethnicity, and/or disease site... if required.

class InvolvementData < ClinicalData
  belongs_to :involvement

  # KEYS = [:race, :gender, :ethnicity]

end

