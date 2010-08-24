class EmpiWorker
  @queue=:empi
  Resque.before_perform_jobs_per_fork do
    # connect_to_empi
    Empi.connect "https://localhost:8443/initiatews/services/IdentityHub?wsdl", { 
      :get    => { :username => "wsget",     :password => "wsget"     },
      :put    => { :username => "wsput",     :password => "wsput"     },
      :merge  => { :username => "wsmerge",   :password => "wsmerge"   },
      :search => { :username => "wssearch",  :password => "wssearch"  } 
    }
  end

  def self.perform(involvement_id)
    # Find the involvement and the subject
    involvement = Involvement.find(involvement_id)
    begin
      study = involvement.study
      if study.read_only?
        puts "I'm not uploading this"
      else
        subject     = involvement.subject
        puts "#{Time.now} I'd be uploading subject #{subject.id} on study #{study.irb_number} to the EMPI"
        # Upload the subject and involvement info to the EMPI
        response = Empi.put({
          :source                       => "eNOTIS", 
          :unique_id                    => subject.id.to_s,
          :first_name                   => subject.first_name,
          :middle_name                  => subject.middle_name, 
          :last_name                    => subject.last_name,
          :primary_street_address_1     => subject.address_line1,
          :primary_street_address_2     => subject.address_line2,
          :primary_city                 => subject.city,
          :primary_state                => subject.state,
          :primary_zip_code             => subject.zip.to_s,
          :gender                       => involvement.gender, 
          :date_of_birth                => subject.birth_date.to_s,
          :record_creation_date         => subject.created_at.to_s
          #MRN? 
        })
        
        #search mrn, ssn, both mrns, 
        subject.update_attributes!(:empi_updated_date => Time.now)
          { 
            :alias_first_name              => [:mem_name,   "ALIASNAME",  :onm_first  ],
            :alias_last_name               => [:mem_name,   "ALIASNAME",  :onm_last   ],
            :cell_phone                    => [:mem_phone,  "CELLPHONE",  :ph_number  ],
            :date_of_birth                 => [:mem_date,   "BIRTHDT",    :date_val   ],
            :death_indicator               => [:mem_attr,   "DEATHIND",   :attr_val   ],
            :drivers_license_number        => [:mem_ident,  "DRVLICENUM", :id_number,   4],
            :email                         => [:mem_attr,   "EMAIL",      :attr_val   ],
            :emergency_contact_first_name  => [:mem_name,   "EMERCONTNM", :onm_first  ],
            :emergency_contact_last_name   => [:mem_name,   "EMERCONTNM", :onm_last   ],
            :emergency_contact_other_phone => [:mem_phone,  "EMERCONTOP", :ph_number  ],
            :emergency_contact_phone       => [:mem_phone,  "EMERCONTPH", :ph_number  ],
            :first_name                    => [:mem_name,   "PATNAME",    :onm_first  ],
            :gender                        => [:mem_attr,   "GENDER",     :attr_val   ],
            :home_phone                    => [:mem_phone,  "HOMEPHONE",  :ph_number  ],
            :idx_medical_record_number     => [:mem_attr,   "IDX_MRN",    :attr_val   ],
            :idx_user_id                   => [:mem_attr,   "IDXUSERID",  :attr_val   ],
            :last_name                     => [:mem_name,   "PATNAME",    :onm_last   ],
            :middle_name                   => [:mem_name,   "PATNAME",    :onm_middle ],
            :next_of_kin_first_name        => [:mem_name,   "NOKNAME",    :onm_first  ],
            :next_of_kin_last_name         => [:mem_name,   "NOKNAME",    :onm_last   ],
            :prefix                        => [:mem_name,   "PATNAME",    :onm_prefix ],
            :previous_first_name           => [:mem_name,   "PREVNAME",   :onm_first  ],
            :previous_last_name            => [:mem_name,   "PREVNAME",   :onm_last   ],
            :primary_city                  => [:mem_addr,   "PATADDRESS", :city       ],
            :primary_country_code          => [:mem_addr,   "PATADDRESS", :country    ],
            :primary_physician_first_name  => [:mem_name,   "PCP",        :onm_first  ],
            :primary_physician_last_name   => [:mem_name,   "PCP",        :onm_last   ],
            :primary_physician_number      => [:mem_attr,   "PCPNUM",     :attr_val   ],
            :primary_state                 => [:mem_addr,   "PATADDRESS", :state      ],
            :primary_street_address_1      => [:mem_addr,   "PATADDRESS", :st_line1   ],
            :primary_street_address_2      => [:mem_addr,   "PATADDRESS", :st_line2   ],
            :primary_zip_code              => [:mem_addr,   "PATADDRESS", :zip_code   ],
            :primes_medical_record_number  => [:mem_attr,   "PRIMES_MRN", :attr_val   ],
            :record_creation_date          => [:mem_date,   "CRTDT",      :date_val   ],
            :record_last_activity_date     => [:mem_date,   "LSTACTDT",   :date_val   ],
            :source                        => [:mem_head,   nil,          :src_code   ],
            :ssn                           => [:mem_ident,  "SSN",        :id_number,   3],
            :suffix                        => [:mem_name,   "PATNAME",    :onm_suffix ],
            :title                         => [:mem_name,   "PATNAME",    :onm_title  ],
            :unique_id                     => [:mem_head,   nil,          :mem_idnum  ],
            :work_phone                    => [:mem_phone,  "WORKPHONE",  :ph_number  ]
          }
      end
    rescue Exception => e
      puts "Something went wrong"
    end
  end
end