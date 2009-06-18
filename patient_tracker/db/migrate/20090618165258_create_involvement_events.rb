class CreateInvolvementEvents < ActiveRecord::Migration
  def self.up
    create_table :involvement_events do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :involvement_events
  end
end
