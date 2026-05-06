class PeriodicNotificationJob < ApplicationJob
  queue_as :default

  # リトライ設定
  sidekiq_options retry: 3

  def perform(user)
    # Do something later
    PlanNotificationMailer.with(user: user).on_time.deliver_later
=begin
    ActionCable.server.broadcast(
      "notifications_#{schedule.user_id}",
      {
        type: 'web_notification',
        title: notification_title(schedule),
        body: notification_body(schedule),
        schedule_id: schedule.id
      }
    )
=end
  end

  def notification_title(schedule)
    case rand(3)
    when 1
      "Daracareだよん"
    when 2
      "Daracareだぜ"
    when 3
      "Daracareダラケア"
    end
  end

  def notification_body(schedule, notification_type)
    case rand(3)
    when 1
      "やあ！順調かな？
        特別な用事はともかく、普段からやらなきゃいけないことってサボりがちになってくるよね。
        えっ、「ならない。むしろサボる方が信じられない」？あはは、偉いですね……。
        このアプリの制作者はサボりがちだからね。私のようなサボりがちを改善するサポートができていればうれしいね。
        それじゃ、引き続きスケジュールに則って頑張ってね。"
    when 2
      "アラートテストです。急に落ち着かないでくれ"
    when 3
      "ちゃんと予定通りに進んでいるか、わたくしめが監督しに来ましたよ。進捗どうですか？"
    end
  end
end
