class AddViewsForSearchTable < ActiveRecord::Migration
  def self.up
    pi_last_name_view = <<-SQL
    CREATE OR REPLACE VIEW pi_last_name AS 
     SELECT s.irb_number, u.last_name
       FROM studies s
       LEFT JOIN roles r ON s.id = r.study_id
       LEFT JOIN users u ON r.user_id = u.id
      WHERE r.project_role = 'Principal Investigator'
    SQL
    pi_last_name_view.squish!
    study_table_view = <<-SQL
    CREATE OR REPLACE VIEW study_tables AS 
    SELECT s.id, 
           s.irb_number, 
           s.name, 
           s.title, 
           s.irb_status AS status, 
           s.irb_status, 
           r.project_role, 
           u.id AS user_id, 
           ( SELECT pi_last_name.last_name
               FROM pi_last_name
              WHERE pi_last_name.irb_number = s.irb_number
             LIMIT 1) AS last_name, 
            COALESCE(count(i.*), 0) AS accrual, 
            COALESCE(s.accrual_goal, 0) AS accrual_goal
    FROM studies s
    LEFT JOIN roles r ON s.id = r.study_id
    LEFT JOIN users u ON r.user_id = u.id
    LEFT JOIN involvements i ON s.id = i.study_id
    GROUP BY s.id, s.irb_number, s.title, s.name, s.irb_status, 
             r.project_role, u.id, u.last_name, s.accrual_goal
    SQL
    study_table_view.squish!
    execute(pi_last_name_view)
    execute(study_table_view)
  end

  def self.down
    execute('drop view study_tables')
    execute('drop view pi_last_name')
  end
end
