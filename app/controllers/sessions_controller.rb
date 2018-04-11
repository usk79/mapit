class SessionsController < ApplicationController
  def new
  end

  def create
    email = params[:session][:email].downcase
    password = params[:session][:password]
    
    if signin(email, password)
      flash[:success] = 'サインインしました'
      
      # sign in したらコレクションを表示
      @collections = current_user.collections
      
      if @collections.size != 0
        @collection = @collections.order(:updated_at).last
        redirect_to controller: 'collections', action: 'index', id: @collection.id
      else
        
        redirect_to controller: 'collections', action: 'index'
      end
    else
      flash[:danger] = 'サインインできませんでした。'
      redirect_to root_url
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = 'サインアウトしました。'
    redirect_to root_url
  end
  
  private
  
  def signin(email, password)
    @user = User.find_by(email: email)
    if @user && @user.authenticate(password)
      # ログイン成功
      session[:user_id] = @user.id
      return true
    else
      # ログイン失敗
      return false
    end
  end
  
end
