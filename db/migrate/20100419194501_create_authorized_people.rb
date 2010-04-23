class CreateAuthorizedPeople < ActiveRecord::Migration
  def self.up
    create_table :authorized_people do |t|
      t.integer :study_id
      t.integer :user_id
      t.string :project_role
      t.string :consent_role
      t.timestamps
    end
    add_index :authorized_people, :study_id
    add_index :authorized_people, :user_id
    add_index :authorized_people, :project_role
    add_index :authorized_people, :consent_role
    execute 'ALTER TABLE authorized_people ADD CONSTRAINT fk_authorized_people_users FOREIGN KEY (user_id) REFERENCES users(id)'
    execute 'ALTER TABLE authorized_people ADD CONSTRAINT fk_authorized_people_studies FOREIGN KEY (study_id) REFERENCES studies(id)'
  end

  def self.down
    execute 'ALTER TABLE authorized_people DROP CONSTRAINT fk_authorized_people_studies'
    execute 'ALTER TABLE authorized_people DROP CONSTRAINT fk_authorized_people_users'    
    remove_index :authorized_people, :consent_role
    remove_index :authorized_people, :project_role
    remove_index :authorized_people, :user_id
    remove_index :authorized_people, :study_id
    drop_table :authorized_people
  end
end
