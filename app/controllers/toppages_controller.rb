class ToppagesController < ApplicationController
  def index
    if logged_in?
      @collections = current_user.collections
      
      if @collections.size != 0
        @collection = @collections.order(:updated_at).last
        redirect_to controller: 'collections', action: 'show', id: @collection.id
      else
        
        redirect_to controller: 'collections', action: 'index'
      end
    end
  end
  

end
