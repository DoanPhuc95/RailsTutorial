class PasswordResetsController < ApplicationController
  before_action :find_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".flash.info"
      redirect_to root_url
    else
      flash.now[:danger] = t ".flash.danger"
      render :new
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t("password_resets.update.empty?")
      render :edit
    elsif @user.update_attributes user_params
      log_in @user
      flash[:success] = t ".flash.success"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def find_user
    @user = User.find_by email: params[:email]
  end

  def valid_user
    unless @user && @user.activated? && @user.authenticated?(:reset,
      params[:id])
      redirect_to root_url
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = t "password_resets.check_expiration.danger"
      redirect_to new_password_reset_url
    end
  end
end