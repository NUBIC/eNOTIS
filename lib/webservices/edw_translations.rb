EDW_TO_NOTIS = {
  'first_nm'                => 'first_name',
  'last_nm'                 => 'last_name',
  'textbox2'                => 'mrn',
  'textbox5'                => 'mrn_type',
  'addr_ln_1_txt'           => 'address_line1',
  'city_nm'                 => 'city',
  'state_nm'                => 'state',
  'zip_code'                => 'zip',
  'home_phone_txt'          => 'phone_number',
  'birth_dts'               => 'birth_date',
  'mrn'                     => 'mrn',
  "last_name"               => :last_name,
  "first_name"              => :first_name,
  "middle_name"             => :middle_name,
  "user_id"                 => :netid,
  "role_in_consent_process" => :consent_role,
  "project_role"            => :project_role
}

NOTIS_TO_EDW = {
  :first_name => "first_nm",
  :last_name  => "last_nm",
  :mrn        => "mrn",
  :birth_date => "birth_dts",
  :netid      => "net_id",
  :irb_number => "irb_number"
}
