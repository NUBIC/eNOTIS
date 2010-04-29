#Exported from eirb queries on Fri Apr 23 14:32:59 -0500 2010
EIRB_TO_NOTIS = {
# eNOTIS Study Contact List 
"Contacts.User ID" =>   :netid,
"ID" =>                 :irb_number,
# eNOTIS Study Export 
"Modified Date" =>   :modified_date,
"ID" =>              :irb_number,
"Created Date" =>    :created_date,
# eNOTIS Study Inclusion Exclusion 
"SF - Subject / Participant Population.Page where the information can be found in the protocol" =>   :population_protocol_page,
"SF - Subject / Participant Population.Exclusion criteria" =>                                        :exclusion_criteria,
"ID" =>                                                                                              :irb_number,
"SF - Subject / Participant Population.Inclusion criteria" =>                                        :inclusion_criteria,
# eNOTIS Study Funding Sources 
"ID" =>                                                                             :irb_number,
"SF - Funding.Funding Source with Award Number.Funding Source.Category.Name" =>     :funding_source_category_name,
"SF - Funding.Funding Source with Award Number.Funding Source.Name" =>              :funding_source_name,
"SF - Funding.Funding Source with Award Number.Funding Source.FundingSourceID" =>   :funding_source_id,
# eNOTIS Study Basics 
"Expired Date" =>                                                                                   :expired_date,
"Date Approved" =>                                                                                  :approved_date,
"Project State.ID" =>                                                                               :irb_status,
"Name" =>                                                                                           :name,
"SF - Subject / Participant Population.Total number of subjects to be enrolled at all centers" =>   :total_subjects_at_all_ctrs,
"Date Expiration" =>                                                                                :expiration_date,
"Study Title" =>                                                                                    :title,
"SF - Subject / Participant Population.Number expected to complete the study" =>                    :subject_expected_completion_count,
"Modified Date" =>                                                                                  :modified_date,
"Completed Date" =>                                                                                 :completed_date,
"ID" =>                                                                                             :irb_number,
"AAHRPP.fdaUnapproved" =>                                                                           :fda_unapproved_agent,
"AAHRPP.fdaOfflabel" =>                                                                             :fda_offlabel_agent,
"clinicalInvestigation" =>                                                                          :is_a_clinical_investigation,
"Created Date" =>                                                                                   :created_date,
"Periodic Review Open" =>                                                                           :periodic_review_open,
"clinicalTrialSubmitter.clinicalTrialSubmitter" =>                                                  :clinical_trial_submitter,
"Date Closed-Completed" =>                                                                          :closed_or_completed_date,
"Review Type - Requested.Name" =>                                                                   :review_type_requested,
"Research Type.Name" =>                                                                             :research_type,
"SF - Subject / Participant Population.Maximum number of subjects to be consented" =>               :accrual_goal,

# eNOTIS Study Accrual 
"Total number of subjects to be enrolled at all centers" =>   :total_subjects_at_all_ctrs,
"ID" =>                                                       :irb_number,
"Subject population.Number of Subjects" =>                    :number_of_study_subjects,
"Maximum number of subjects to be consented" =>               :accrual_goal,
"Multi institution study" =>                                  :is_multi_institute_study,
# eNOTIS Study Access 
"ID" =>                     :irb_number,
"Study Access.User ID" =>   :netid,
# eNOTIS Study Coordinators 
"ID" =>                                        :irb_number,
"Study Staff - Study Coordinator.User ID" =>   :netid,
# eNOTIS Study Authorized Personnel 
"SF - Authorized Personnel.Authorized Personnel.Person.User ID" =>                                        :netid,
"SF - Authorized Personnel.Authorized Personnel.Person.Contact Information.E-mail: Preferred.E-Mail" =>   :email,
"ID" =>                                                                                                   :irb_number,
"SF - Authorized Personnel.Authorized Personnel.Role is consent process" =>                               :consent_role,
"SF - Authorized Personnel.Authorized Personnel.Project Role" =>                                          :project_role,
# eNOTIS Study Description 
"ID" =>            :irb_number,
"Description" =>   :description,
# eNOTIS Study Status 
"Project State.ID" =>   :irb_status,
"ID" =>                 :irb_number,
# eNOTIS Study Principal Investigator 
"ID" =>                                             :irb_number,
"Study Staff - Principal Investigator.User ID" =>   :netid,
# eNOTIS Recently Updated Studies 
"Project State.ID" =>   :irb_status,
"ID" =>                 :irb_number,
# eNOTIS Study Subject Populations 
"SF - Subject / Participant Population.Subject population.Number of Subjects" =>        :number_of_subjects,
"SF - Subject / Participant Population.Subject population.Subject Population.Name" =>   :population_name,
"ID" =>                                                                                 :irb_number,
"SF - Subject / Participant Population.Subject population.ID" =>                        :population_id,
"SF - Subject / Participant Population.Subject population.Other" =>                     :other_txt,
# eNOTIS Study Co-Investigators 
"Study Staff - Co-Investigators.User ID" =>   :netid,
"ID" =>                                       :irb_number,
}


NOTIS_TO_EIRB = {
  :name         => "Name",
  :title        => "Study Title",
  :irb_number   => "ID",
  :description  => "Description",
  :status       => "Project Status.ID",
  :netid        => "NETID" 
}
