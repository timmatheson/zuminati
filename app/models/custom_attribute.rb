class CustomAttribute < ActiveRecord::Base
  attr_accessible :name, :owner_id, :value

  belongs_to :owner

  validates :name, :presence => true
  validates :value, :presence => true
end
