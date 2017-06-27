class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def new
  end

  def create
    @micropost = current_user.microposts.build micropost_params
    if @micropost.save
      flash[:success] = t "success"
      redirect_to root_url
    else
      flash[:danger] = t "flash_danger"
      redirect_to home_path
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = t "success"
    redirect_to request.referer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit :content, :picture
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    unless @micropost
      flash[:danger] = t "flash_danger"
      redirect_to root_url
    end
  end
end
