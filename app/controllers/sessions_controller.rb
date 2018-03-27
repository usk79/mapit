class SessionsController < ApplicationController
  def new
  end

  def create
    email = params[:session][:email].downcase
    password = params[:session][:password]
    
    if signin(email, password)
      flash[:success] = 'サインインしました'
      redirect_to root_url
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
