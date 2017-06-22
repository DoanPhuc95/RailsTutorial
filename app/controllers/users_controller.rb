class UsersController < ApplicationController
  before_action :find_user, only: [:show, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    user = @user
    if user.save
      log_in user
      flash[:success] = t "welcome"
      redirect_to user
    else
      render :new
    end
  end

  def show
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def find_user
    @user = User.find_by id: params[:id]
    unless @user
      flash[:danger] = t "invalid_login"
      redirect_to signup_url
    end
  end
end
