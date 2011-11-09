# This model represents the affiliation a subject can have with a
# study.  It holds non-temporal data only. For reporting purposes we
# capture gender, ethnicity, and race here
#
# For example: Disease site would be found in the Involvement join
# record between a subject and study.  Disease site is a specific
# piece of data about why the subject is on the trial but not
# associated with a specific event. It is a long term data element
# that can span the whole relationship of subject and study.

require 'ruport'
class Involvement < ActiveRecord::Base

  # Constants
  # These correspond to the fields in the database for storing race
  RACE_ATTRIBUTES = {
    :race_is_american_indian_or_alaska_native          => "American Indian/Alaska Native",
    :race_is_asian                                     => "Asian",
    :race_is_black_or_african_american                 => "Black/African American",
    :race_is_native_hawaiian_or_other_pacific_islander => "Native Hawaiian/Other Pacific Islander",
    :race_is_white                                     => "White",
    :race_is_unknown_or_not_reported                   => "Unknown or Not Reported"
  }.freeze

  # Mixins
  has_paper_trail
  acts_as_reportable

  # Associations
  belongs_to :subject
  belongs_to :study
  has_many :involvement_events, :dependent => :destroy
  has_many :response_sets, :dependent => :destroy

  before_create :set_uuid

  # Atrributes
  accepts_nested_attributes_for :involvement_events,
    :reject_if => lambda {|a| (a["occurred_on"].blank?) }
  accepts_nested_attributes_for :subject, :update_only=>true

  # Named scope
  default_scope :order => "case_number"
  # TODO: WTF is this? does this scope even work?
  named_scope :with_coordinator, lambda {|user_id| {
    :include => {:study => :coordinators},
    :conditions => ['coordinators.user_id = ?', user_id ]}}

  named_scope :with_event_type, lambda {|event_type| {
    :include => :involvement_events,
    :conditions => ['involvement_events.event_type_id = ?',event_type]}}

  # Validations
  validates_presence_of :gender, :ethnicity, :study
  # Custom validator for race
  validate do |inv|
    checked = false
    RACE_ATTRIBUTES.each_key do |k|
      t = inv.send(k)
      checked ||= inv.send(k)
    end
    unless checked
      inv.errors.add_to_base(
        "One of the race categories must be selected. If you do not know the race choose 'Unknown or Not Reported'")
    end
  end

  # Public class methods
  class << self
    def gender_definitions
      { "Male"                    => "A person identifying with the male sex or gender",
        "Female"                  => "A person identifying with the female sex or gender",
        "Unknown or Not Reported" => "A person not wishing to identify their gender or this person's gender is unknown" }
    end

    def translate_gender(val)
      [ /^M(ale)?$/i, "Male",
        /^F(emale)?$/i, "Female",
        /Unknown|Not Reported|^U$|^NR$/i, "Unknown or Not Reported" ].each_slice(2){|rx, term| return term if val.to_s.match(rx)}
    end

    def ethnicity_definitions
      { "Hispanic or Latino"      => "A person of Cuban, Mexican, Puerto Rican, South or Central American, or other Spanish culture or origin, regardless of race. The term \"Spanish origin\" can also be used in addition to \"Hispanic or Latino.\"",
        "Not Hispanic or Latino"  => "A person NOT of Cuban, Mexican, Puerto Rican, South or Central American, or other Spanish culture or origin, regardless of race.",
        "Unknown or Not Reported" => "Individuals not reporting ethnicity" }
    end

    def translate_ethnicity(val)
      [ /^Hispanic|^Latino/i, "Hispanic or Latino",
        /^Not (Hispanic|Latino)/i, "Not Hispanic or Latino",
        /Unknown|Not Reported|^U$|^NR$/i, "Unknown or Not Reported" ].each_slice(2){|rx, term| return term if val.to_s.match(rx)}
    end

    def race_definitions
      { "American Indian/Alaska Native"          => "A person having origins in any of the original peoples of North, Central, or South America, and who maintains tribal affiliations or community attachment.",
        "Asian"                                  => "A person having origins in any of the original peoples of the Far East, Southeast Asia, or the Indian subcontinent including, for example, Cambodia, China, India, Japan, Korea, Malaysia, Pakistan, the Philippine Islands, Thailand, and Vietnam.",
        "Black/African American"                 => "A person having origins in any of the black racial groups of Africa.",
        "Native Hawaiian/Other Pacific Islander" => "A person having origins in any of the original peoples of Hawaii, Guam, Samoa, or other Pacific Islands.",
        "White"                                  => "A person having origins in any of the original peoples of Europe, the Middle East, or North Africa.",
        "Unknown or Not Reported"                => "A person not wishing to identify their race or this person's race is unknown" }
    end

    def translate_race(val)
      [ /^American Indian|^Alaskan?|^Native American/i, "American Indian/Alaska Native",
        /^Asian?$/i, "Asian",
        /^Black|^African/i, "Black/African American",
        /^(Native )?Hawaiian|Pacific Islander/i, "Native Hawaiian/Other Pacific Islander",
        /^White|^Caucasian/i, "White",
        /^Unknown|^Not Reported|^U$|^NR$/i, "Unknown or Not Reported" ].each_slice(2){|rx, term| return term if val.to_s.match(rx)}
    end

    # genders, ethnicities, races
    %w(gender ethnicity race).each do |category|
      define_method("#{category.pluralize}".to_sym){ self.send("#{category}_definitions").keys }
    end

    def update_or_create(params)
      if (ie = Involvement.find(:first, :conditions => {:study_id => params[:study_id], :subject_id => params[:subject_id]}))
        ie.update_attributes(params)
        ie
      else
        Involvement.create(params)
      end
    end

    # Takes a study and the bulk update data which contains an array of hashes.
    # The hashes contain study participant/subject info
    def import_update(study, bulk_data)
      bulk_data.each do |inv_hash| # iterating over each involvement hash
        s = inv_hash[:subject]
        if s[:external_patient_id].nil? or s[:import_source].nil?
          raise "Subject hash is missing external_id and source. These are required for imported subject data"
        end
        subject = Subject.find_by_external_id(s[:external_patient_id],s[:import_source])
        if subject.nil?
          subject = Subject.create(s)
        end

        #look for study/subject involvements already existing
        inv = Involvement.find(:first,
          :conditions => {:study_id => study.id, :subject_id => subject.id})
        if inv.nil? # create it
          inv_data = inv_hash[:involvement].
            merge({:study_id => study.id, :subject_id => subject.id})
          # removing this set of data to add manually (vs using accepts nested attrs for)
          inv_data.delete(:involvement_events)
          inv = study.involvements.create(inv_data)
        end

        # creating new events
        inv_hash[:involvement][:involvement_events].each do |event_sym,event_date|
          event_name = event_sym.to_s.split('_')[0].capitalize
          event_type = study.event_types.find_by_name(event_name)
          occurred = event_date.split("T").join(" ")
          ie = inv.involvement_events.find(:first, :conditions => {:event_type_id => event_type.id})
          unless ie
            InvolvementEvent.create(
              :involvement => inv, :event_type => event_type, :occurred_on => occurred)
          else
            ie.occurred_on = occurred # updating teh date
            ie.save
          end
        end

        # cleaning up the inv events no longer in the inv_hash
        inv.involvement_events.each do |ie|
          e_key = "#{ie.event.downcase}_date".to_sym
          unless inv_hash[:involvement][:involvement_events].has_key?(e_key)
            InvolvementEvent.delete(ie)
          end
        end

      end #end bulk data loop

      # cleaning up involvements no longer in the inv_hash
      subject_ids = bulk_data.map{|x| x[:subject][:external_patient_id]}
        study.involvements.each do |current_inv|
         unless subject_ids.include?(current_inv.subject.external_patient_id)
           Involvement.destroy(current_inv)
         end
      end
    end


  end # end of class << self

  %w(gender ethnicity).each do |category|
    # gender=, ethnicity= (make case insensitive)
    define_method("#{category}=") do |term|
      write_attribute(category.to_sym,
        self.class.send(category.pluralize).detect { |x| x.downcase == term.to_s.downcase })
    end
  end

  # Sets the races by accepting an array or string of race terms
  def races=(terms)
    #clearing out any previous values
    clear_all_races
    rterms = ([] << terms).flatten # takes a string or an array and makes it into an array
    if rterms.include?("Unknown or Not Reported") # don't set any thing else
       self.race_is_unknown_or_not_reported = true
    else
      set_race_terms(rterms)
    end
  end

  # Returns the races as the defined strings. Pulled out of the attribute fields
  def races
    race_array = []
    RACE_ATTRIBUTES.each_key do |k|
      if send(k) == true
        race_array << RACE_ATTRIBUTES[k]
      end
    end
    race_array.sort
  end

  alias :race :races
  alias :race= :races=

  def races_as_str
    races.join(", ")
  end

  def race_for_nih_report
    races.size == 1 ? races.first : "More Than One Race"
  end

  alias :race_as_str :races_as_str

  # A setter for the race_is_unknown_or_not_reported attribute
  # because it has to clear all other races
  # NOTE: Checking for "1" or true because rails passes the params
    # to the set attr methods as "1"s or "0"s from the checkboxes.
    # I'm assuming there is some magic going on to set the other model
    # attributes to their boolean values from the "1"s or "0"s
  def unknown_or_not_reported_race=(val)
    if val == true || val == "1"
      clear_all_races
      self.race_is_unknown_or_not_reported = true
    elsif val == false || val == "0"
      self.race_is_unknown_or_not_reported = false
    end
  end

  # The getter so the checkbox will work
  def unknown_or_not_reported_race
    self.race_is_unknown_or_not_reported
  end

  # Used for graphs
  def short_ethnicity
    return "" if ethnicity.blank?
    (ethnicity[0..12].length == ethnicity.length) ? ethnicity : ethnicity[0..10] + "..."
  end

  def short_race
    return "" if race.blank?
    return "multiple" if races.size > 1
    (races.first[0..12].length == races.first.length) ? races.first : races.first[0..10] + "..."
  end

  def short_gender
    return "" if gender.blank?
    (gender[0..12].length == gender.length) ? gender : gender[0..10] + "..."
  end
  # END of methods used for graphs

  def all_events
    # A placeholder method to get an easy checkbox?
    # Not sure why this is here but it's "method" is
    # used when generating reports. Basically it's used as
    # a flag, this method is never actually called
    # as far as I can tell. - BLC
  end

  # Generating some methods for the reporting plugin
  %w(consented withdrawn completed).each  do |name|
    define_method("#{name}_report".to_sym) do
       ev = self.send(:event_detect, name)
       ev.occurred_on if ev
    end
    define_method(name.to_sym) do
      self.send(:event_detect, name)
    end
  end

  def completed_or_withdrawn
    completed || withdrawn
  end

  # This method deliberately does not go to the database. This allows
  # it to be called performantly over long lists of involvements by
  # preloading the involvement_events across every instance in the
  # list.
  def event_detect(ev_name)
    involvement_events.detect { |e| e.event_type.name.downcase == ev_name.downcase }
  end

  def subject_name_or_case_number
    subject.name.blank? ? case_number : subject.name
  end

  def single_line_ie_export
    involvement_events.collect{ |ev| "#{ev.event_type.name} -- #{ev.occurred_on}" }.join("\n")
  end

  def subject_name
    subject.name
  end

  def first_name
    subject.first_name
  end

  def last_name
    subject.last_name
  end

  def nmff_mrn
    subject.nmff_mrn
  end

  def nmh_mrn
    subject.nmh_mrn
  end

  def ric_mrn
    subject.ric_mrn
  end
  def address
    return nil if address_line1.blank? and address_line2.blank? and city.blank? and state.blank? and zip.blank?
    "#{self.address_line1} #{self.address_line2} \n #{self.city} #{self.state} #{self.zip}"
  end



  named_scope :empi_eligible, :joins => :study, :conditions => ['studies.read_only = ? or studies.read_only IS NULL', false]
  
  def self.keyed_by_subject_id(collection)
    collection.inject({}) do |mem, inv|
      subj_id = inv.subject.id
      mem[subj_id] ||= []
      mem[subj_id] << inv unless mem[subj_id].include?(inv)
      mem
    end
  end
  
  def self.empi_exportable
    keyed_by_subject_id(empi_eligible).values.collect do |involvments|
      involvments.compact.sort{ |i1, i2| i1.updated_at <=> i2.updated_at }.last
    end
  end

  private

  def set_uuid
    self.uuid = UUID.generate if self.uuid.blank?
  end
  def set_race_terms(rterms)
    rterms.map(&:downcase).each do |term|
      by_term = {}
      RACE_ATTRIBUTES.each{|k,v| by_term[v.downcase] = k} # Doing this because the conts is frozen
      by_term.each_key {|k| k.downcase} #downcasing the term strings
      if by_term.keys.include?(term)
        send("#{by_term[term]}=",true) #setting the db attr for the race term passed in
      end
    end
  end

  def clear_all_races # includes the :race_is_unknown_or_not_reported "race"
    RACE_ATTRIBUTES.each_key{|ra| send("#{ra}=", false)}
  end
end
