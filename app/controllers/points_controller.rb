class PointsController < ApplicationController
  #protect_from_forgery except: :new 
  # gmapから座標情報を送ろうとするときActionController::InvalidAuthenticityTokenが出たため、ここだけ除外
  
  #TODO: pointの作成・編集・削除操作はコレクションをフォローしているユーザのみに限定する
  #TODO: 現在のzoom値を読み取って、使用するhttp://www.openspc2.org/reibun/Google/Maps/API/ver3/code/map/center/0101/index.html
  
  def new
    
    #TODO:　緯度経度情報が正しいかチェック　ダメならflash
    @point = Point.new(lat: params[:addPointLat], lng: params[:addPointLng])
    @points = Point.all
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
  
  def edit
    @point = Point.find(params[:id])
    @points = Point.where.not(id: @point.id)
  end
  
  def update
    @point = Point.find(params[:id])
    
    prms = point_params
    
    if prms[:lat] == nil || prms[:lng] == nil
      flash.now[:danger] = '座標情報がありません。'
      render :new
    end
    
    if @point.update(prms)
      flash[:success] = 'ポイント情報を更新しました!'
      redirect_to dummy_url #TODO: dummy修正
    else
      flash.now[:danger] = 'ポイント情報の更新に失敗しました。'
      render :edit
    end
  end
  
  def destroy
    @point = Point.find(params[:id])
    @point.destroy
    
    flash[:success] = 'ポイントを削除しました。'
    redirect_to dummy_url #TODO: dummy修正
  end
  
  private
  
  def point_params
    prms = params.require(:point).permit(:name, :lat, :lng, :description, :address)
    
    prms[:created_by] = current_user.id
    
    prms
  end

end
