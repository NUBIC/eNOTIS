class RemoveUsersTable < ActiveRecord::Migration
  def self.up
    Role.all.each do |role|
      role.netid = User.find(role.user_id).netid
      result = role.save
      puts "save netid: #{role.netid} to study #{role.study.irb_number} 'failed'" unless result 
    end
    execute('drop view study_tables') #removing views built on the user table
    execute('drop view pi_last_name')
    execute 'ALTER TABLE roles DROP CONSTRAINT fk_authorized_people_studies' #cleaning up a mistake
    execute 'ALTER TABLE roles DROP CONSTRAINT fk_authorized_people_users'
    remove_index(:roles,:index_authorized_people_on_user_id)
    remove_column :roles, :user_id
    add_index(:roles, :netid, :unique => false, :name => 'roles_netid_idx' )
    drop_table :users
  end

  def self.down
    add_column :roles, :netid, :string
    create_table :users do |t|
      t.string :netid
      t.string :email
      t.string :title
      t.string :first_name
      t.string :middle_name
      t.string :last_name 
      t.string :address_line1
      t.string :address_line2
      t.string :address_line3
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.string :phone_number
      t.timestamps
    end
    
    # adding netid index
    add_index(:users, :netid, :unique => true, :name => 'users_netid_idx' )
  end
end
