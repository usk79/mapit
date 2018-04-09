class CollectionsController < ApplicationController
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
  end

  def index
    @collections = current_user.collections
      
      if @collections.size == 0
        @collection = Collection.new(name: "←メニューを開いてコレクションを作成しましょう! ")
      end
  end

  def show
    @collections = current_user.collections
    @collection = @collections.find_by(id: params[:id])
    redirect_to my_collections_url if !@collections 
    
    @points = @collection.points.all
  end
  
  private
  def collection_params
    prms = params.require(:collection).permit(:name, :description, :collection_type)
    
    prms[:collection_type] = prms[:collection_type].to_i
    
    prms[:created_by] = current_user.id
    
    prms
  end
  
end
