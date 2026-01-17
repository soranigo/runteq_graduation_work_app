class PeriodicNotificationJob < ApplicationJob
  queue_as :default

  def perform(user)
    # Do something later
    PlanNotificationMailer.with(user: user).on_time.deliver_later
  end
end
