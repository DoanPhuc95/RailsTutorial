class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> b6f646417c9434e114a5d778eaf0bce485f68c28
      flash[:success] = t ".flash.success"
      redirect_to user
    else
      flash[:danger] = t ".flash.danger"
<<<<<<< HEAD
=======
=======
      flash[:success] = t "activate_success"
      redirect_to user
    else
      flash[:danger] = t "danger"
>>>>>>> 8fa26fd7495c3826d80d7a06da0fde75dd8b44a2
>>>>>>> b6f646417c9434e114a5d778eaf0bce485f68c28
      redirect_to root_url
    end
  end
end
