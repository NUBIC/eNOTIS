class NetidData < ActiveRecord::Migration
  def self.up
    puts "Processing Role data"
    Role.all.each do |role|
      role.netid = User.find(role.user_id).netid
      result = role.save
      print "."
      puts "save netid: #{role.netid} to study #{role.study.irb_number} 'failed'" unless result 
    end
    puts "Done with Roles"

    puts "Processing StudyUpload data"
    StudyUpload.all.each do |su|
      su.netid = User.find(su.user_id).netid
      result = su.save
      print "."
      puts "save netid: #{su.netid} to study #{su.study.irb_number} 'failed'" unless result 
    end
    puts "Done with StudyUploads"

    puts "Processing Activity data"
    Activity.all.each do |a|
      a.whodiddit = User.find(a.whodiddit).netid
      result = a.save
      print "."
      puts "save netid: #{a.netid} to activity #{a.inspect} 'failed'" unless result 
    end
    puts "Done with Activities"
    
    # execute('drop view study_tables') #removing views built on the user table
    # execute('drop view pi_last_name')
    # execute 'ALTER TABLE roles DROP CONSTRAINT fk_authorized_people_studies' #cleaning up a mistake
    # execute 'ALTER TABLE roles DROP CONSTRAINT fk_authorized_people_users'
    # puts "Dropped search view and fks" 

    # Cleaning up the tables and columns we don't need any more
    # remove_index(:roles,:index_authorized_people_on_user_id)
    # remove_column(:roles, :user_id)
    # remove_column(:study_uploads, :user_id)
    # drop_table :users
    # puts "Removed columns, index, and users table" 

    # adding lookup index
    add_index(:roles, :netid, :unique => false, :name => 'roles_netid_idx' )
    puts "Migration finished!"
  end

  def self.down
    # puts "Rolling back the changes... data loss occuring"
    # add_column :roles, :netid, :string
    # create_table :users do |t|
    #   t.string :netid
    #   t.string :email
    #   t.string :title
    #   t.string :first_name
    #   t.string :middle_name
    #   t.string :last_name 
    #   t.string :address_line1
    #   t.string :address_line2
    #   t.string :address_line3
    #   t.string :city
    #   t.string :state
    #   t.string :zip
    #   t.string :country
    #   t.string :phone_number
    #   t.timestamps
    # end
    # 
    # # adding netid index
    # add_index(:users, :netid, :unique => true, :name => 'users_netid_idx' )
  end
end
