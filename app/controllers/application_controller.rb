class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  include SessionsHelper
  
  def public_user
    User.find(1)
  end
  
  def find_from_public_collection(id)
    public_user.collections.find_by(id: id)
  end

  
  private
  
  def require_user_logged_in
    unless logged_in?
      redirect_to signin_url
    end
  end
end
