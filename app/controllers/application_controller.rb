class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_gmapkey
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
  
  def set_gmapkey
    if Rails.env.production?
      @gmap_key = 'AIzaSyAqKNbKg15mXDaj3hDLpgIfrIDWYtSMdSQ'
    else
      @gmap_key = 'AIzaSyAIJfGcO2u5nHVWO-b7O4pAfPrta3U3EHc'
    end
  end
  
end
