class AddFkConstraints < ActiveRecord::Migration
  def self.up
    drop_table :principal_investigators
    drop_table :co_investigators
    drop_table :coordinators
  end

  def self.down
    create_table "coordinators", :force => true do |t|
      t.integer  "study_id"
      t.integer  "user_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "co_investigators", :force => true do |t|
      t.integer  "study_id"
      t.integer  "user_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "principal_investigators", :force => true do |t|
      t.integer  "study_id"
      t.integer  "user_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
