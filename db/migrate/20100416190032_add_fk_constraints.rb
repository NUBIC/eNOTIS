class AddFkConstraints < ActiveRecord::Migration
  def self.up
    
    execute 'ALTER TABLE co_investigators ADD CONSTRAINT fk_co_investigators_users FOREIGN KEY (user_id) REFERENCES users(id)'
    execute 'ALTER TABLE co_investigators ADD CONSTRAINT fk_co_investigators_studies FOREIGN KEY (study_id) REFERENCES studies(id)'
    
    execute 'ALTER TABLE coordinators ADD CONSTRAINT fk_coordinators_users FOREIGN KEY (user_id) REFERENCES users(id)'
    execute 'ALTER TABLE coordinators ADD CONSTRAINT fk_coordinators_studies FOREIGN KEY (study_id) REFERENCES studies(id)'
    
    execute 'ALTER TABLE principal_investigators ADD CONSTRAINT fk_principal_investigators_users FOREIGN KEY (user_id) REFERENCES users(id)'
    execute 'ALTER TABLE principal_investigators ADD CONSTRAINT fk_principal_investigators_studies FOREIGN KEY (study_id) REFERENCES studies(id)'
  end

  def self.down
    execute 'ALTER TABLE principal_investigators DROP CONSTRAINT fk_principal_investigators_studies'
    execute 'ALTER TABLE principal_investigators drop CONSTRAINT fk_principal_investigators_users'
    
    execute 'ALTER TABLE coordinators DROP CONSTRAINT fk_coordinators_studies'
    execute 'ALTER TABLE coordinators DROP CONSTRAINT fk_coordinators_users'
    
    execute 'ALTER TABLE co_investigators DROP CONSTRAINT fk_co_investigators_studies'
    execute 'ALTER TABLE co_investigators DROP CONSTRAINT fk_co_investigators_users'
  end
end
