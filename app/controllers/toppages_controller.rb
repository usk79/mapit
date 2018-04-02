class ToppagesController < ApplicationController
  def index
    redirect_to my_collections_url if logged_in?
  end
  
  def my_collections
    @points = Point.all
    
  end
end
