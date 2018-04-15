class ToppagesController < ApplicationController
  def index
    if logged_in?
        redirect_to controller: 'collections', action: 'index'
    else
      @public_collections = public_user.collections
    end
  end
  

end
