class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:show]
  
  def show
    #TODO: ユーザー詳細
  end

  def new
    @user = User.new
  end

  def create
    prms = user_params
    
    @user = User.new(prms)
    
    if User.find_by(name: prms[:name])
      flash.now[:danger] = '既に登録されているユーザ名です。'
      render :new
    elsif User.find_by(email: prms[:email])
      flash.now[:danger] = '既に登録されているEmailです。'
      render :new
    elsif prms[:name].length < 4 ||  prms[:name].length > 20
      flash.now[:danger] = 'ユーザー名は4文字以上、20文字以下にしてください。'
      render :new
    elsif prms[:password].length < 8
      flash.now[:danger] = 'パスワードは8文字以上にしてください。'
      render :new
    else

      if @user.save
        flash[:success] = 'ユーザを登録しました。'
        redirect_to @user
      else
        flash.now[:danger] = 'ユーザの登録に失敗しました。'
        render :new
      end
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
