#Exported from eirb queries on Sat Jan 09 18:33:39 -0600 2010
EIRB_TO_NOTIS = {

# eNOTIS Study Subject Populations 
"Subject population.ID" =>      :subject_population_id,
"Number of Subjects" =>         :subject_count,
"ID" =>                         :irb_number,
"Subject population Other" =>   :subject_population_other,
"Subject Population Name" =>    :subject_population_name,
# eNOTIS Study Basics 
"Name" =>                                                                                           :name,
"SF - Research Subject Involvement.Subject Involvement.Name" =>                                     :subject_involvement_name,
"SF - Investigational Drugs/Biologics.Non-FDA approved drug.IND Number" =>                          :non_fda_ind,
"Date Expiration" =>                                                                                :expired_date,
"Study Title" =>                                                                                    :title,
"Date Approved" =>                                                                                  :approved_date,
"Project State.ID" =>                                                                               :irb_status,
"SF - Subject / Participant Population.Total number of subjects to be enrolled at all centers" =>   :total_subjects_at_all_ctrs,
"SF - Subject / Participant Population.Multi institution study" =>                                  :multi_inst_study,
"SF - Investigational Devices.FDA Cleared Unapproved Use.IDE number" =>                             :fda_cleared_unapproved_ide,
"ID" =>                                                                                             :irb_number,
"SF - Research Subject Involvement.Subject Involvement.Type" =>                                     :subject_involvment_type,
"SF - Investigational Devices.Non-FDA Cleared.IDE number" =>                                        :non_fda_cleared_ide,
"Periodic Review Open" =>                                                                           :perodic_review_open,
"Date Closed-Completed" =>                                                                          :date_closed_or_completed,
"SF - Investigational Devices.Non Significant Risk" =>                                              :devices_non_significant_risk,
"Research Type.Name" =>                                                                             :research_type,
"SF - Subject / Participant Population.Maximum number of subjects to be consented" =>               :max_subjects_to_be_consented,
"SF - Investigational Drugs/Biologics.FDA approved unapproved use.IND Number" =>                    :fda_approved_unapproved_use_ind,
# eNOTIS Study Authorized Personnel 
"SF - Authorized Personnel.Authorized Personnel.Person.Training Certification.Certification Completion Date" =>   :cert_complete_date,
"SF - Authorized Personnel.Authorized Personnel.Person.Training Certification.Other Description/Note" =>          :cert_descr,
"SF - Authorized Personnel.Authorized Personnel.Date Created" =>                                                  :cert_created_date,
"SF - Authorized Personnel.Authorized Personnel.Person.First Name" =>                                             :first_name,
"SF - Authorized Personnel.Authorized Personnel.Person.Training Type.TrainingType" =>                             :training_type,
"SF - Authorized Personnel.Authorized Personnel.Date Modified" =>                                                 :modified_date,
"SF - Authorized Personnel.Authorized Personnel.Person.User ID" =>                                                :netid,
"ID" =>                                                                                                           :irb_number,
"SF - Authorized Personnel.Authorized Personnel.Person.Training Certification.Training Verified" =>               :training_verified,
"SF - Authorized Personnel.Authorized Personnel.Project Role" =>                                                  :project_role,
# eNOTIS Study Key Research Personnel 
"SF - Authorized Personnel.Key Research Personnel.Last Name" =>                  :last_name,
"SF - Authorized Personnel.Key Research Personnel.First Name" =>                 :first_name,
"ID" =>                                                                          :irb_number,
"SF - Authorized Personnel.Key Research Personnel.Date Modified" =>              :modified_date,
"SF - Authorized Personnel.Key Research Personnel.Email Address" =>              :email,
"SF - Authorized Personnel.Key Research Personnel.Institution" =>                :institution,
"SF - Authorized Personnel.Key Research Personnel.Role in Research Project" =>   :project_role,
"SF - Authorized Personnel.Key Research Personnel.Phone Number" =>               :phone,
"SF - Authorized Personnel.Key Research Personnel.Date Created" =>               :create_date,
# eNOTIS Study Key Research Personnel 
"SF - Authorized Personnel.Key Research Personnel.Last Name" =>                  :last_name,
"SF - Authorized Personnel.Key Research Personnel.First Name" =>                 :first_name,
"ID" =>                                                                          :irb_number,
"SF - Authorized Personnel.Key Research Personnel.Date Modified" =>              :modified_date,
"SF - Authorized Personnel.Key Research Personnel.Email Address" =>              :email,
"SF - Authorized Personnel.Key Research Personnel.Institution" =>                :institution,
"SF - Authorized Personnel.Key Research Personnel.Role in Research Project" =>   :project_role,
"SF - Authorized Personnel.Key Research Personnel.Phone Number" =>               :phone,
"SF - Authorized Personnel.Key Research Personnel.Date Created" =>               :created_date,
# eNOTIS Study Status 
"Project State.ID" =>   :status,
"ID" =>                 :irb_number,
# eNOTIS Study Coordinators 
"Study Staff - Study Coordinator.Contact Information.E-mail: Preferred.E-Mail" =>   :email,
"Study Staff - Study Coordinator.Last Name" =>                                      :last_name,
"Study Staff - Study Coordinator.Employer.Name" =>                                  :employer,
"Project State.ID" =>                                                               :irb_status,
"Study Staff - Study Coordinator.First Name" =>                                     :first_name,
"ID" =>                                                                             :irb_number,
"Study Staff - Study Coordinator.User ID" =>                                        :netid,
# eNOTIS Study Access 
"Study Access.User ID" =>                                        :netid,
"Study Access.Last Name" =>                                      :last_name,
"Project State.ID" =>                                            :irb_status,
"Study Access.First Name" =>                                     :first_name,
"ID" =>                                                          :irb_number,
"Study Access.Contact Information.E-mail: Preferred.E-Mail" =>   :email,
# eNOTIS Study Accrual PR 
"SF - Number of Research Subjects.Subjects consented to date" =>                    :subjects_consented_to_date,
"Parent Study.ID" =>                                                                :irb_number,
"Date Expiration" =>                                                                :expiration_date,
"Date Received" =>                                                                  :received_date,
"Date Approved" =>                                                                  :approved_date,
"Project State.ID" =>                                                               :status,
"PReviewID" =>                                                                      :pr_number,
"Date Study Last Reviewed" =>                                                       :last_reviewed_date,
"SF - Number of Research Subjects.Total subjects across multiple institutions" =>   :subject_total_all_insts,
"SF - Number of Research Subjects.Consent form for each" =>                         :each_consented,
"SF - Number of Research Subjects.Subjects withdrawn" =>                            :subjects_withdrawn,
# eNOTIS Study Principal Investigator 
"Project State.ID" =>                                                                    :irb_status,
"Study Staff - Principal Investigator.Title" =>                                          :title,
"Study Staff - Principal Investigator.First Name" =>                                     :first_name,
"Study Staff - Principal Investigator.Last Name" =>                                      :last_name,
"ID" =>                                                                                  :irb_number,
"Study Staff - Principal Investigator.User ID" =>                                        :netid,
"Study Staff - Principal Investigator.Employer.Name" =>                                  :employer,
"Study Staff - Principal Investigator.Temporary Department" =>                           :temp_department,
"Study Staff - Principal Investigator.Contact Information.E-mail: Preferred.E-Mail" =>   :email,
# eNOTIS Study Co-Investigators 
"Study Staff - Co-Investigators.Title" =>                                          :title,
"Study Staff - Co-Investigators.First Name" =>                                     :first_name,
"Project State.ID" =>                                                              :irb_status,
"Study Staff - Co-Investigators.Employer.Name" =>                                  :employer,
"Study Staff - Co-Investigators.User ID" =>                                        :netid,
"ID" =>                                                                            :irb_number,
"Study Staff - Co-Investigators.Contact Information.E-mail: Preferred.E-Mail" =>   :email,
"Study Staff - Co-Investigators.Last Name" =>                                      :last_name,
"Study Staff - Co-Investigators.Temporary Department" =>                           :temp_department,
}

# EIRB_TO_NOTIS = {
# "Contacts.User ID" => :netid,
# "Contacts.Last Name" => :last_name,
# "User ID" => :netid,
# "Title" => :title,
# "Last Name" => :last_name,
# "First Name" => :first_name,
# "Middle Name" => :middle_name,
# "Contact Information.Address: Business.City" => :city,
# "Contact Information.Address: Business.Country.ID" => :country,
# "Contact Information.Address: Business.First Line" => :address_line1, 
# "Contact Information.Address: Business.Postal Code" => :zip,
# "Contact Information.Address: Business.Second Line" => :address_line2, 
# "Contact Information.Address: Business.State or Province.ID" => :state,
# "Contact Information.Address: Business.Third Line" => :address_line3,
# "Contact Information.E-mail: Preferred.E-Mail" => :email, 
# "Contact Information.Phone: Business.Phone Number" => :phone_number,
# "Contact Information.Phone: Fax.Phone Number" => :fax_number,
# "Created Date" => :eirb_create_date,
# #Study translations
# "Study Staff - Study Coordinator.Contact Information.E-mail: Preferred.E-Mail"=> :sc_email,
# "Study Staff - Study Coordinator.First Name"=> :sc_first_name,
# "Study Staff - Study Coordinator.Last Name"=> :sc_last_name,
# "Study Staff - Principal Investigator.First Name"=> :pi_first_name,
# "Study Staff - Principal Investigator.Last Name"=> :pi_last_name, 
# "Study Staff - Principal Investigator.User ID"=> :pi_netid, 
# "Study Staff - Principal Investigator.Contact Information.E-mail: Preferred.E-Mail"=> :pi_email,
# "Study Staff - Study Coordinator.User ID"=> :sc_netid, 
# "Research Type.Name"=> :research_type,
# "ID"=> :irb_number,
# "Name"=> :name,
# "Study Title"=> :title, 
# "Project State.ID"=> :status,
# "Multi institution study" => :multi_inst_study,
# "Maximum number of subjects to be consented" => :max_subjects_to_be_consented,
# "Total number of subjects to be enrolled at all centers" => :total_subject_at_all_ctrs,
# "Subject population.Number of Subjects" => :subject_population
# }
# 
NOTIS_TO_EIRB = {
  :name         => "Name",
  :title        => "Study Title",
  :irb_number   => "ID",
  :description  => "Description",
  :status       => "Project Status.ID",
  :netid        => "UserID" 
}