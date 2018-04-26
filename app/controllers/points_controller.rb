class PointsController < ApplicationController
  #protect_from_forgery except: :new 
  # gmapから座標情報を送ろうとするときActionController::InvalidAuthenticityTokenが出たため、ここだけ除外
  
  #TODO: pointの作成・編集・削除操作はコレクションをフォローしているユーザのみに限定する
  #TODO: 現在のzoom値を読み取って、使用するhttp://www.openspc2.org/reibun/Google/Maps/API/ver3/code/map/center/0101/index.html
  before_action :require_user_logged_in
  before_action :set_collection
  before_action :set_point, only: [:show, :edit, :update, :destroy]
  
  
  def new
    #TODO:　緯度経度情報が正しいかチェック　ダメならflash
    @point = Point.new(lat: params[:addPointLat], lng: params[:addPointLng])
    @points = @collection.points.where.not(id: @point.id)
  end

  def create
    prms = point_params
    
    @point = @collection.points.build(prms)
    
    flash.now[:danger] = prms[:image]
    render :new
    
#    if prms[:lat] == nil || prms[:lng] == nil
#      flash.now[:danger] = '座標情報がありません。'
#      render :new
#    elsif @point == nil
#      flash.now[:danger] = 'ポイントの追加に失敗しました。'
#      render :new
#    else
#      if @point.save
#        
#        @collection.touch #タイムスタンプを更新
#        @collection.save  
#        
#        flash[:success] = 'ポイントをコレクションしました!'
#        redirect_to controller: 'collections', action: 'show', id: @collection
#      else
#        flash.now[:danger] = 'ポイントの追加に失敗しました。'
#        render :new
#      end
#    end
    
  end
  
  def show
    @points = @collection.points.where.not(id: @point.id)
    
    @comments = @point.comments
    @comment = Comment.new
  end
  
  def edit
    @points = @collection.points.where.not(id: @point.id)
  end
  
  def update
    
    prms = point_params
    
    flash.now[:danger] = 'ポイント情報の更新に失敗しました。'
    render :edit
    
    if prms[:lat] == nil || prms[:lng] == nil
      flash.now[:danger] = '座標情報がありません。'
      render :edit
    else
      prms[:image] ||= @point.image
       
      if @point.update(prms)
        @collection.touch #タイムスタンプを更新
        @collection.save
        
        flash[:success] = 'ポイント情報を更新しました!'
        redirect_to controller: 'collections', action: 'show', id: @collection
      else
        flash.now[:danger] = 'ポイント情報の更新に失敗しました。'
        render :edit
      end
      
    end
  end
  
  def destroy
    @point.destroy
    
    @collection.touch #タイムスタンプを更新
    @collection.save
    
    flash[:success] = 'ポイントを削除しました。'
    redirect_to controller: 'collections', action: 'show', id: @collection
  end
  
  private
  
  def set_point
    @point = @collection.points.find_by(id: params[:id])
    redirect_to root_url if @point == nil
  end
  
  def set_collection
    @collection = current_user.collections.find_by(id: params[:collection]) # ログインユーザが所有している or
    @collection ||= find_from_public_collection(params[:collection]) # ログインユーザがフォローしている
  end
  
  def point_params
    prms = params.require(:point).permit(:name, :lat, :lng, :description, :address, :collection_id, :image)
    
    prms[:created_by] = current_user.id
    prms[:collection_id] = prms[:collection_id].to_i
    prms
  end

end
