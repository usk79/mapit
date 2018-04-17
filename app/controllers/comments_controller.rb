class CommentsController < ApplicationController
  before_action :require_user_logged_in
    
  def create
    prms = comment_params
    
    @point = Point.find_by(id: prms[:point_id])
    
    @comment = @point.comments.build(prms)
    
    if prms[:content] == '' || prms[:content] == nil
      flash[:danger] = 'コメントを投稿できませんでした。'
      redirect_back(fallback_location: root_path)
    else
    
      if @comment.save
        flash[:success] = 'コメントを投稿しました。'
        redirect_back(fallback_location: root_path)
      else
        flash[:danger] = 'コメントを投稿できませんでした。'
        redirect_back(fallback_location: root_path)
      end
    end
      
  end
  
  def destroy
    @comment = current_user.comments.find_by(id: params[:id])
    redirect_to root_url if @comment == nil
    @comment.destroy
    
    flash[:success] = 'コメントを削除しました。'
    redirect_back(fallback_location: root_path)
  end
  
  private

  def comment_params
    prms = params.require(:comment).permit(:content, :point_id, :user_id)
  end
end
