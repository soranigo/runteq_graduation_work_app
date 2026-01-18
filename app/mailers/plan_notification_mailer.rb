class PlanNotificationMailer < ApplicationMailer
  default from: "kabyi9540@gmail.com"

  def on_time
    @user = params[:user]
    mail(to: @user.email, subject: "予定通りに進んでるかな？")
  end
end
