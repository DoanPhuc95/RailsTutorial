class UsersController < ApplicationController
  before_action :find_user, only: :show
  before_action :logged_in_user, except: [:new, :create]
  before_action :correct_current_user, only: [:edit, :update]

  def index
    @users = User.activated
  end

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
    unless @user
      flash[:danger] = t "invalid_login"
      redirect_to signup_url
    end
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "profile_updated"
      redirect_to @user
    else
      redirect_to :edit
    end
  end

  def destroy
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def find_user
    @user = User.find_by id: params[:id]
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t "please_login"
      redirect_to login_url
    end
  end

  def correct_current_user
    redirect_to root_url unless @user.current_user? current_user
  end
end
