class ToppagesController < ApplicationController
    before_action :login_check, only:[:index, :show]
    
  def index
    @public_collections = public_user.collections
  end
  
  def show
    @public_collections = public_user.collections
    @collection = @public_collections.find_by(id: params[:id])
    @points = @collection.points
  end
  
  def help
    
  end
  
  private
  def login_check
    redirect_to controller: 'collections', action: 'index' if logged_in?
  end
end
