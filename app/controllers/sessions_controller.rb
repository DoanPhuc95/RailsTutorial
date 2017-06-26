class SessionsController < ApplicationController
  before_action :find_user, only: :create

  def create
    user = @user
    params_session = @params_session
    if user && user.authenticate(params_session[:password])
      log_in user
      params_session[:remember_me] == "1" ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash.now[:danger] = t "invalid_login"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private
  def find_user
    @params_session = params[:session]
    @user = User.find_by email: @params_session[:email].downcase
    unless @user
      flash[:danger] = t "invalid_login"
      redirect_to login_url
    end
  end
end
