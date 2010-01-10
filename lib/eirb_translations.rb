#Exported from eirb queries on Sat Jan 09 18:24:37 -0600 2010
EIRB_TO_NOTIS = {
# eNOTIS Study Subject Populations 
"Subject population.ID" =>      "NEW_VALUE"
"Number of Subjects" =>         "NEW_VALUE"
"ID" =>                         "irb_number"
"Subject population Other" =>   "NEW_VALUE"
"Subject Population Name" =>    "NEW_VALUE"
# eNOTIS Study Basics 
"Name" =>                                                                                           "name"
"SF - Research Subject Involvement.Subject Involvement.Name" =>                                     "NEW_VALUE"
"SF - Investigational Drugs/Biologics.Non-FDA approved drug.IND Number" =>                          "NEW_VALUE"
"Date Expiration" =>                                                                                "NEW_VALUE"
"Study Title" =>                                                                                    "title"
"Date Approved" =>                                                                                  "NEW_VALUE"
"Project State.ID" =>                                                                               "status"
"SF - Subject / Participant Population.Total number of subjects to be enrolled at all centers" =>   "NEW_VALUE"
"SF - Subject / Participant Population.Multi institution study" =>                                  "NEW_VALUE"
"SF - Investigational Devices.FDA Cleared Unapproved Use.IDE number" =>                             "NEW_VALUE"
"ID" =>                                                                                             "irb_number"
"SF - Research Subject Involvement.Subject Involvement.Type" =>                                     "NEW_VALUE"
"SF - Investigational Devices.Non-FDA Cleared.IDE number" =>                                        "NEW_VALUE"
"Periodic Review Open" =>                                                                           "NEW_VALUE"
"Date Closed-Completed" =>                                                                          "NEW_VALUE"
"SF - Investigational Devices.Non Significant Risk" =>                                              "NEW_VALUE"
"Research Type.Name" =>                                                                             "research_type"
"SF - Subject / Participant Population.Maximum number of subjects to be consented" =>               "NEW_VALUE"
"SF - Investigational Drugs/Biologics.FDA approved unapproved use.IND Number" =>                    "NEW_VALUE"
# eNOTIS Study Authorized Personnel 
"FAILED" =>   "NEW_VALUE"
# eNOTIS Study Key Research Personnel 
"SF - Authorized Personnel.Key Research Personnel.Last Name" =>                  "NEW_VALUE"
"SF - Authorized Personnel.Key Research Personnel.First Name" =>                 "NEW_VALUE"
"ID" =>                                                                          "irb_number"
"SF - Authorized Personnel.Key Research Personnel.Date Modified" =>              "NEW_VALUE"
"SF - Authorized Personnel.Key Research Personnel.Email Address" =>              "NEW_VALUE"
"SF - Authorized Personnel.Key Research Personnel.Institution" =>                "NEW_VALUE"
"SF - Authorized Personnel.Key Research Personnel.Role in Research Project" =>   "NEW_VALUE"
"SF - Authorized Personnel.Key Research Personnel.Phone Number" =>               "NEW_VALUE"
"SF - Authorized Personnel.Key Research Personnel.Date Created" =>               "NEW_VALUE"
# eNOTIS Study Status 
"Project State.ID" =>   "status"
"ID" =>                 "irb_number"
# eNOTIS Study Coordinators 
"Study Staff - Study Coordinator.Contact Information.E-mail: Preferred.E-Mail" =>   "sc_email"
"Study Staff - Study Coordinator.Last Name" =>                                      "sc_last_name"
"Study Staff - Study Coordinator.Employer.Name" =>                                  "NEW_VALUE"
"Project State.ID" =>                                                               "status"
"Study Staff - Study Coordinator.First Name" =>                                     "sc_first_name"
"ID" =>                                                                             "irb_number"
"Study Staff - Study Coordinator.User ID" =>                                        "sc_netid"
# eNOTIS Study Access 
"Study Access.User ID" =>                                        "NEW_VALUE"
"Study Access.Last Name" =>                                      "NEW_VALUE"
"Project State.ID" =>                                            "status"
"Study Access.First Name" =>                                     "NEW_VALUE"
"ID" =>                                                          "irb_number"
"Study Access.Contact Information.E-mail: Preferred.E-Mail" =>   "NEW_VALUE"
# eNOTIS Study Accrual PR 
"SF - Number of Research Subjects.Subjects consented to date" =>                    "NEW_VALUE"
"Parent Study.ID" =>                                                                "NEW_VALUE"
"Date Expiration" =>                                                                "NEW_VALUE"
"Date Received" =>                                                                  "NEW_VALUE"
"Date Approved" =>                                                                  "NEW_VALUE"
"Project State.ID" =>                                                               "status"
"ID" =>                                                                             "irb_number"
"Date Study Last Reviewed" =>                                                       "NEW_VALUE"
"SF - Number of Research Subjects.Total subjects across multiple institutions" =>   "NEW_VALUE"
"SF - Number of Research Subjects.Consent form for each" =>                         "NEW_VALUE"
"SF - Number of Research Subjects.Subjects withdrawn" =>                            "NEW_VALUE"
# eNOTIS Study Principal Investigator 
"Project State.ID" =>                                                                    "status"
"Study Staff - Principal Investigator.Title" =>                                          "NEW_VALUE"
"Study Staff - Principal Investigator.First Name" =>                                     "pi_first_name"
"Study Staff - Principal Investigator.Last Name" =>                                      "pi_last_name"
"ID" =>                                                                                  "irb_number"
"Study Staff - Principal Investigator.User ID" =>                                        "pi_netid"
"Study Staff - Principal Investigator.Employer.Name" =>                                  "NEW_VALUE"
"Study Staff - Principal Investigator.Temporary Department" =>                           "NEW_VALUE"
"Study Staff - Principal Investigator.Contact Information.E-mail: Preferred.E-Mail" =>   "pi_email"
# eNOTIS Study Co-Investigators 
"Study Staff - Co-Investigators.Title" =>                                          "NEW_VALUE"
"Study Staff - Co-Investigators.First Name" =>                                     "NEW_VALUE"
"Project State.ID" =>                                                              "status"
"Study Staff - Co-Investigators.Employer.Name" =>                                  "NEW_VALUE"
"Study Staff - Co-Investigators.User ID" =>                                        "NEW_VALUE"
"ID" =>                                                                            "irb_number"
"Study Staff - Co-Investigators.Contact Information.E-mail: Preferred.E-Mail" =>   "NEW_VALUE"
"Study Staff - Co-Investigators.Last Name" =>                                      "NEW_VALUE"
"Study Staff - Co-Investigators.Temporary Department" =>                           "NEW_VALUE"
}

EIRB_TO_NOTIS = {
"Contacts.User ID" => :netid,
"Contacts.Last Name" => :last_name,
"User ID" => :netid,
"Title" => :title,
"Last Name" => :last_name,
"First Name" => :first_name,
"Middle Name" => :middle_name,
"Contact Information.Address: Business.City" => :city,
"Contact Information.Address: Business.Country.ID" => :country,
"Contact Information.Address: Business.First Line" => :address_line1, 
"Contact Information.Address: Business.Postal Code" => :zip,
"Contact Information.Address: Business.Second Line" => :address_line2, 
"Contact Information.Address: Business.State or Province.ID" => :state,
"Contact Information.Address: Business.Third Line" => :address_line3,
"Contact Information.E-mail: Preferred.E-Mail" => :email, 
"Contact Information.Phone: Business.Phone Number" => :phone_number,
"Contact Information.Phone: Fax.Phone Number" => :fax_number,
"Created Date" => :eirb_create_date,
#Study translations
"Study Staff - Study Coordinator.Contact Information.E-mail: Preferred.E-Mail"=> :sc_email,
"Study Staff - Study Coordinator.First Name"=> :sc_first_name,
"Study Staff - Study Coordinator.Last Name"=> :sc_last_name,
"Study Staff - Principal Investigator.First Name"=> :pi_first_name,
"Study Staff - Principal Investigator.Last Name"=> :pi_last_name, 
"Study Staff - Principal Investigator.User ID"=> :pi_netid, 
"Study Staff - Principal Investigator.Contact Information.E-mail: Preferred.E-Mail"=> :pi_email,
"Study Staff - Study Coordinator.User ID"=> :sc_netid, 
"Research Type.Name"=> :research_type,
"ID"=> :irb_number,
"Name"=> :name,
"Study Title"=> :title, 
"Project State.ID"=> :status,
"Multi institution study" => :multi_inst_study,
"Maximum number of subjects to be consented" => :max_subjects_to_be_consented,
"Total number of subjects to be enrolled at all centers" => :total_subject_at_all_ctrs,
"Subject population.Number of Subjects" => :subject_population
}

NOTIS_TO_EIRB = {
  :name         => "Name",
  :title        => "Study Title",
  :irb_number   => "ID",
  :description  => "Description",
  :status       => "Project Status.ID",
  :netid        => "UserID" 
}
