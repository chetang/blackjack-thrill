class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name
  has_many :games
  validates_presence_of :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
end
