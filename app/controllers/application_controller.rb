class ApplicationController < ActionController::Base
  protect_from_forgery
  def set_current_user(user)
  	self.current_user(user)
  end

  def current_user=(user)
  	@current_user = user
  end

  def current_user
  	@current_user
  end

end
