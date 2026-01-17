class PeriodicNotificationJob < ApplicationJob
  queue_as :default

  # リトライ設定
  sidekiq_options retry: 3

  def perform(user)
    # Do something later
    PlanNotificationMailer.with(user: user).on_time.deliver_later
  end
end
