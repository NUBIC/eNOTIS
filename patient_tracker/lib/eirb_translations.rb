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
"Contact Information.Address: Business.Postal Code" => :postal_code,
"Contact Information.Address: Business.Second Line" => :address_line2, 
"Contact Information.Address: Business.State or Province.ID" => :state,
"Contact Information.Address: Business.Third Line" => :address_line3,
"Contact Information.E-mail: Business.E-Mail" => :email, 
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
"Project State.ID"=> :status
}

NOTIS_TO_EIRB = {
  :name         => "Name",
  :title        => "Study Title",
  :irb_number   => "ID",
  :description  => "Description",
  :status       => "Project Status.ID",
  :netid        => "UserID" 
}
