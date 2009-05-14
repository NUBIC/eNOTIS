class Involvement < ActiveRecord::Base
  belongs_to :protocol
  belongs_to :patient
end
