class PlanNotificationMailer < ApplicationMailer
  default from: "notifications@example.com"

  def on_time
    @user = params[:user]
    mail(to: @user.email, subject: "予定通りに進んでるかな？")
  end
end
