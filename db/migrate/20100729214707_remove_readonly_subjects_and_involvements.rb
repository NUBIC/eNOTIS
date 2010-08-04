class RemoveReadonlySubjectsAndInvolvements < ActiveRecord::Migration
  def self.up 
    InvolvementEvent.paper_trail_off
    Involvement.paper_trail_off
    Subject.paper_trail_off
    
    Involvement.find_each(:include=>[:study, :involvement_events], :conditions => {:studies => {:read_only => true}}) do |involvement|
      say_with_time "Removing #{involvement.involvement_events.count} Events for involvement #{involvement.id}" do
        involvement.involvement_events.destroy_all
      end
    end
    
    say_with_time "Deleting subjects without any involvements" do
      Subject.all(:select =>  "subjects.id", 
      :joins  =>  "left join involvements on subjects.id = involvements.subject_id ",
      :group  =>  "subjects.id", 
      :having =>  "count(involvements)=0").each { |subject| subject.destroy }
    end
    
    execute 'ALTER TABLE involvement_events ADD CONSTRAINT fk_ie_involvements FOREIGN KEY (involvement_id) REFERENCES involvements(id) ON DELETE CASCADE'
    execute 'ALTER TABLE involvements ADD CONSTRAINT fk_inv_subjects FOREIGN KEY (subject_id) REFERENCES subjects(id)'
    execute 'ALTER TABLE involvements ADD CONSTRAINT fk_inv_studies FOREIGN KEY (study_id) REFERENCES studies(id)'
    
    add_column :subjects, :external_patient_id, :integer
    add_column :subjects, :data_source, :string
    add_index :subjects, :external_patient_id
    Subject.paper_trail_on
    Involvement.paper_trail_on
    InvolvementEvent.paper_trail_on
  end

  def self.down
    remove_index :subjects, :external_patient_id
    remove_column :subjects, :data_source
    remove_column :subjects, :external_patient_id
    execute 'ALTER TABLE involvements DROP CONSTRAINT fk_inv_studies'
    execute 'ALTER TABLE involvements DROP CONSTRAINT fk_inv_subjects'
    execute 'ALTER TABLE involvement_events DROP CONSTRAINT fk_ie_involvements'
  end
end
