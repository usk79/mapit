class ToppagesController < ApplicationController
  def index
    if logged_in?
        redirect_to controller: 'collections', action: 'index'
    end
  end
  

end
