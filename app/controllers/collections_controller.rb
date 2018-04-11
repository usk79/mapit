class CollectionsController < ApplicationController
  
  before_action :set_collection, only: [:show, :edit, :update, :destroy]
    
  def new
    @collection = Collection.new
  end

  def create
    prms = collection_params
    
    @collection = current_user.collections.build(prms)
    
    if prms[:name] == nil || prms[:name] == ''
      flash.now[:danger] = 'コレクション名は必須です。'
      render :new
    elsif prms[:collection_type] < 0 || prms[:collection_type] > 1
      flash.now[:danger] = '不正な値が入力されました。'
      render :new
    else
      if @collection.save
        flash[:success] = 'コレクションを作成しました!'
        redirect_to root_url
      else
        flash.now[:danger] = 'コレクションの作成に失敗しました。'
        render :new
      end
    end
  end
  
  def edit
    
  end

  def update
    prms = collection_params
    
    if prms[:name] == ''
      flash.now[:danger] = 'コレクション名は必須です。'
      render :edit
    else
      if @collection.update(prms)
        flash[:success] = 'コレクション情報を更新しました!'
        redirect_to root_url
      else
        flash.now[:danger] = 'コレクション情報の更新に失敗しました。'
        render :edit
      end
    end
  end
  
  def info
    @collection = current_user.collections.find_by(id: params[:id])
  end
  
  def index
    @collections = current_user.collections
    
    if @collections.size != 0
      @collection = @collections.order(:updated_at).last
      @points = @collection.points.all
      @no_collection = false
    else
      @no_collection = true
      @collection = Collection.new(name: "←メニューを開いてコレクションを作成しましょう! ")
    end
  end

  def show
    @points = @collection.points.all
  end
  
   def destroy
    @collection.destroy
    
    flash[:success] = 'コレクションを削除しました。'
    redirect_to root_url
  end
  
  private
  
  def collection_params
    prms = params.require(:collection).permit(:name, :description, :collection_type)
    
    prms[:collection_type] = prms[:collection_type].to_i
    
    prms[:created_by] = current_user.id
    
    prms
  end
  
  def set_collection()
    @collections = current_user.collections
    @collection = @collections.find_by(id: params[:id])
    
    redirect_to root_url if @collection == nil
  end
  
end
