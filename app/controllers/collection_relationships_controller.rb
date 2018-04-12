class CollectionRelationshipsController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    collection = Collection.find(params[:collection_id])
    current_user.follow(collection)
    flash[:success] = 'コレクションをフォローしました。'
    redirect_back(fallback_location: root_path)
  end

  def destroy
    collection = Collection.find(params[:collection_id])
    current_user.unfollow(collection)
    flash[:success] = 'コレクションのフォローを解除しました。'
    redirect_back(fallback_location: root_path)
  end 
  
end
