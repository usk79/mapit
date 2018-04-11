class PointsController < ApplicationController
  #protect_from_forgery except: :new 
  # gmapから座標情報を送ろうとするときActionController::InvalidAuthenticityTokenが出たため、ここだけ除外
  
  #TODO: pointの作成・編集・削除操作はコレクションをフォローしているユーザのみに限定する
  #TODO: 現在のzoom値を読み取って、使用するhttp://www.openspc2.org/reibun/Google/Maps/API/ver3/code/map/center/0101/index.html
  
  before_action :set_point, only: [:show, :edit, :update, :destroy]
  
  def new
    #TODO:　緯度経度情報が正しいかチェック　ダメならflash
    
    @collection = current_user.collections.find_by(id: params[:collection])
    
    @point = Point.new(lat: params[:addPointLat], lng: params[:addPointLng])
    @points = Point.all
  end

  def create
    prms = point_params
    
    @collection = current_user.collections.find_by(id: prms[:collection_id])
    @point = @collection.points.build(prms)
    
    if prms[:lat] == nil || prms[:lng] == nil
      flash.now[:danger] = '座標情報がありません。'
      render :new
    elsif @point == nil
      flash.now[:danger] = 'ポイントの追加に失敗しました。'
      render :new
    else
      if @point.save
        flash[:success] = 'ポイントをコレクションしました!'
        redirect_to root_url
      else
        flash.now[:danger] = 'ポイントの追加に失敗しました。'
        render :new
      end
    end
    
  end
  
  def show
    @points = @collection.points.where.not(id: @point.id)
  end
  
  def edit
    @points = @collection.points.where.not(id: @point.id)
  end
  
  def update
    
    prms = point_params
    
    if prms[:lat] == nil || prms[:lng] == nil
      flash.now[:danger] = '座標情報がありません。'
      render :edit
    else
    
      if @point.update(prms)
        flash[:success] = 'ポイント情報を更新しました!'
        redirect_to root_url
      else
        flash.now[:danger] = 'ポイント情報の更新に失敗しました。'
        render :edit
      end
      
    end
  end
  
  def destroy
    @point.destroy
    
    flash[:success] = 'ポイントを削除しました。'
    redirect_to root_url
  end
  
  private
  
  def set_point
    @collection = current_user.collections.find_by(id: params[:collection])
    @point = @collection.points.find_by(id: params[:id])
    redirect_to root_url if @point == nil
  end
  
  def point_params
    prms = params.require(:point).permit(:name, :lat, :lng, :description, :address, :collection_id)
    
    prms[:created_by] = current_user.id
    prms[:collection_id] = prms[:collection_id].to_i
    prms
  end

end
