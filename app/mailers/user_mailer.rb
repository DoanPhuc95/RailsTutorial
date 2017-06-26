class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: @user.email, subject: t("users.form.activate")
  end

  def password_reset user
    @user = user
    mail to: @user.email, subject: t("users.form.reset_pass")
  end
end
