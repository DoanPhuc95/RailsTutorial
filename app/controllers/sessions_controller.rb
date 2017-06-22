class SessionsController < ApplicationController
  before_action :find_user, only: :create

  def create
    user = @user
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to user
    else
      flash.now[:danger] = t "invalid_login"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  private
  def find_user
    @user = User.find_by email: params[:session][:email].downcase
    unless @user
      flash[:danger] = t "invalid_login"
      redirect_to login_url
    end
  end
end
