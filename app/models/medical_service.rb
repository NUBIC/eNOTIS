class MedicalService < ActiveRecord::Base
  belongs_to :study

  before_save :set_date_if_complete
  
  def set_date_if_complete
    if self.completed?
      self.completed_at = Time.now
    end
  end

  # Logic for completed-ness
  def completed? 

    #checking for nils
    # True if any nils
    base_nils = self.current_enrollment.nil? ||
    self.expected_enrollment.nil? ||
    self.expected_clinical_services.nil? || 
    self.uses_services_before_completed.nil?

    #cheking for positive ints
    top_nums = (self.current_enrollment >= 0 && 
      self.expected_enrollment >= 0 && 
      self.expected_clinical_services >= 0) unless base_nils 

    if !base_nils and top_nums and 
      self.uses_services_before_completed == false
      return true
    elsif !base_nils and top_nums and
      self.uses_services_before_completed == true
      
      #checking for nils
      sub_nils = self.expects_bedded_outpatients.nil? ||
      self.expects_bedded_inpatients.nil? || 
      self.involves_pharmacy.nil? ||
      self.involves_labs_pathology.nil? ||
      self.involves_imaging.nil?

      if !sub_nils && 
        self.expects_bedded_inpatients == false
        return true
      elsif !sub_nils &&
        self.expects_bedded_inpatients == true
        
        if !self.bedded_inpatient_days_research.nil? &&
          self.bedded_inpatient_days_research >= 0 &&
          !self.bedded_inpatient_days_standard_care.nil? && 
          self.bedded_inpatient_days_standard_care >= 0
          return true
        end
      end
    end
    return false
  end
end
