class PointsController < ApplicationController
  #protect_from_forgery except: :new 
  # gmapから座標情報を送ろうとするときActionController::InvalidAuthenticityTokenが出たため、ここだけ除外
  
  def new
    @point = Point.new(lat: params[:addPointLat], lng: params[:addPointLng])
  end

  def create
    prms = point_params
    
    @point = Point.new(prms)
    
    if prms[:lat] == nil || prms[:lng] == nil
      flash.now[:danger] = '座標情報がありません。'
      render :new
    end
    
    if @point.save
      flash[:success] = 'ポイントをコレクションしました!'
      redirect_to dummy_url #TODO: dummy修正
    else
      flash.now[:danger] = 'ポイントの追加に失敗しました。'
      render :new
    end
    
  end
  
  def show
    @point = Point.find(params[:id])
    @points = Point.where.not(id: @point.id)
  end
  
  private
  
  def point_params
    prms = params.require(:point).permit(:name, :lat, :lng, :description, :address)
    
    prms[:created_by] = current_user.id
    
    prms
  end

end
