==RESQUE
http://github.com/defunkt/resque
http://github.com/blog/542-introducing-resque

To install redis
  brew install redis
  edit /usr/local/etc/redis.conf 
    set daemonize yes
    set bind 127.0.0.1
  
To start redis
    redis-server /usr/local/etc/redis.conf
    
To start workers 
  cd RAILS_ROOT && JOBS_PER_WORKER=100 COUNT=4 QUEUES=<any queue> rake environment resque:workers

Nightly Importing Process (Locally)
1) Start SSH tunnel for BCSEC-LDAP: sudo ssh -f -N -L 636:directory.northwestern.edu:636 sjg304@enotis-staging.nubic.northwestern.edu

Then , open up 4 tabs in Terminal.app and type these commands (at RAILS_ROOT)
rake eirb:redis_import:full
JOBS_PER_FORK=25 COUNT=3 QUEUES=redis_study_populator rake environment resque:workers
JOBS_PER_FORK=25 COUNT=3 QUEUES=redis_authorized_personnel_populator,redis_ldapper,redis_bogus_netid rake environment resque:workers

For the Nightly Work
rake eirb:redis_import:nightly
QUEUES=* rake resque:work   
JOBS_PER_FORK=25 COUNT=2 QUEUES=redis_study_populator rake environment resque:workers
JOBS_PER_FORK=25 COUNT=2 QUEUES=redis_bogus_netid,redis_ldapper,redis_authorized_personnel_populator rake environment resque:workers

For checking on resque progress on staging setup an SSH tunnel on staging and change the resque and redis config locally
ssh -f -N -L 6380:q-staging.nubic.northwestern.edu:6379 sjg304@enotis-staging.nubic.northwestern.edu

For checking on resque progress on production setup an SSH tunnel on staging and change the resque and redis config locally
ssh -f -N -L 6380:q-prod.nubic.northwestern.edu:6379 sjg304@enotis-staging.nubic.northwestern.edu

To view resque jobs locally simply go to /admin/jobs and type in the username and password enotis_jobs

eNOTIS Redis Data Dictionary:
All eNOTIS keys are start with eNOTIS
All eNOTIS resque keys start with resque:eNOTIS
500 Involvements
500 Subjects
500 Involvement Events
USERS ====

User - stored as Hash
  eNOTIS:user:NETID
  ex - eNOTIS:user:sjg304

User in eIRB but not in LDAP - stored as Hash
  eNOTIS:missing_person:NETID
  ex - eNOTIS:missing_person:kba920

Users without proper netid that we've been able to identify by their name of email address
  Stored as hash
  eNOTIS:role:user_aliases


STUDIES ====

Study - stored as Hash
  eNOTIS:study:IRB_NUMBER
  ex - eNOTIS:study:STU00019833

Study Funding Source - stored as Hash
  eNOTIS:study:IRB_NUMBER:funding_source:INCREMENT
  ex - eNOTIS:study:STU00018724:funding_source:0

Studies that subjects are on but do not show up in eIRB/eNOTIS 
  (from subject import from NOTIS) - stored as Set
  eNOTIS:missing:study

Daily Study Import - stored as Set
  eNOTIS:import:study:daily:YEAR:HOUR:DAY-HOUR:MIN:AM/PM
  ex - eNOTIS:import:study:daily:2010:07:11-12:00:AM

Phantom Studies = stored as Set
  May not be needed anymore
  eNOTIS:phantom_studies
  
ROLES ====

Principal Investigators - stored as Set
  eNOTIS:role:principal_investigators:IRB_NUMBER 
  ex - eNOTIS:role:principal_investigators:STU00005555 

Co Investigators - stored as Set
  eNOTIS:role:co_investigators:IRB_NUMBER
  ex - eNOTIS:role:co_investigators:STU00003692

Authorized Personnel - stored as Set
  eNOTIS:role:authorized_people:IRB_NUMBER
  ex - eNOTIS:role:authorized_people:STU00016666

Individual Authorized Personnel - stored as Hash
  eNOTIS:role:authorized_personnel:IRB_NUMBER:NETID
  ex - eNOTIS:role:authorized_personnel:STU00004081:mbr607

Authorized Personnel unable to login via eNOTIS - stored as Hash
  eNOTIS:role:missing_person:IRB_NUMBER:NETID
  ex - eNOTIS:role:missing_person:STU00028756:kki670


SUBJECTS ====

Subject - stored as Hash
  eNOTIS:subject:IRB_NUMBER:PATIENT_ID:INCREMENT
  ex - eNOTIS:subject:STU00011037:65294:0
  
Extra Imported Subjects - stored as Set
  eNOTIS:import:subject_extras:daily:YEAR:HOUR:DAY-HOUR:MIN:AM/PM
  ex - eNOTIS:import:subject_extras:daily:2010:07:11-03:12:AM
  
