class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name
  has_many :games
  validates_presence_of :email
end
