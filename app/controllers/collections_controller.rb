class CollectionsController < ApplicationController
  before_action :require_user_logged_in
  before_action :set_collection, only: [:show, :edit, :update, :destroy, :info]
  before_action :set_edit_control, only: [:info, :edit, :update, :destroy]
    
  def new
    @collection = Collection.new
  end

  def create
    prms = collection_params
    
    if prms[:collection_type] == 0                      # Public Collection
      @collection = public_user.collections.build(prms)
    else                                                # Private Collection
      @collection = current_user.collections.build(prms)
    end
    
    if prms[:name] == nil || prms[:name] == ''
      flash.now[:danger] = 'コレクション名は必須です。'
      render :new
    elsif prms[:name].size > 40
      flash.now[:danger] = 'コレクション名は40文字までです。'
      render :new
    elsif prms[:collection_type] < 0 || prms[:collection_type] > 1
      flash.now[:danger] = '正しくないデータが入力されました。'
      render :new
    else
      if @collection.save
        
        if @collection.collection_type == 0
          current_user.follow(@collection)
        end
        
        flash[:success] = 'コレクションを作成しました!'
        redirect_to controller: 'collections', action: 'show', id: @collection
      else
        flash.now[:danger] = 'コレクションの作成に失敗しました。'
        render :new
      end
    end
  end
  
  def edit
    redirect_to root_url if !@edit_control
  end

  def update
    redirect_to root_url if !@edit_control
    
    prms = collection_params
    
    if prms[:name] == ''
      flash.now[:danger] = 'コレクション名は必須です。'
      render :edit
    elsif prms[:collection_type] < 0 || prms[:collection_type] > 1
      flash.now[:danger] = '正しくないデータが入力されました。'
      render :edit
    elsif @collection.followers.size >=2 && prms[:collection_type] != @collection.collection_type
      flash.now[:danger] = "#{current_user.name}さん以外にフォロワーが存在するためコレクションのタイプを変更できません。"
      render :edit
    else # パラメータにエラーが無いとき
      if prms[:collection_type] == 0 && @collection.collection_type == 1 # privateからpublicに変更するとき
        prms[:user_id] = 1
        current_user.follow(@collection)
      end
      
      prms[:image] ||= @collection.image
      
      if @collection.update(prms)
        flash[:success] = 'コレクション情報を更新しました!'
        redirect_to controller: 'collections', action: 'info', id: @collection
      else
        flash.now[:danger] = 'コレクション情報の更新に失敗しました。'
        render :edit
      end
    end
  end
  
  def info
   
  end
  
  def index
    @collections = current_user.collections
    @follow_collections = current_user.follow_collections
    
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
  
  def show_public
    @public_collections = public_user.collections
  end
  
   def destroy
    redirect_to root_url if !@edit_control
    
    if @collection.followers.size < 2
      @collection.destroy
    
      flash[:success] = 'コレクションを削除しました。'
      redirect_to root_url
    else
      flash.now[:danger]  = "#{current_user.name}さん以外にフォロワーが存在するためコレクションを削除できません。"
      render :edit
    end
  end
  
  private
  
  def collection_params
    prms = params.require(:collection).permit(:name, :description, :collection_type, :image)
    
    prms[:collection_type] = prms[:collection_type].to_i
    
    prms[:created_by] = current_user.id
    
    prms
  end
  
  def set_collection()
    @collections = current_user.collections
    @follow_collections = current_user.follow_collections
    
    @collection = @collections.find_by(id: params[:id]) 
    @collection ||= find_from_public_collection(params[:id])
    
    redirect_to root_url if @collection == nil
  end
  
  def set_edit_control
    @edit_control = @collection.user.id == current_user.id || @collection.created_by == current_user.id
  end
  
end
