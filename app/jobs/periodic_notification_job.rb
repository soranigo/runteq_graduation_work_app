class PeriodicNotificationJob < ApplicationJob
  queue_as :default

  # リトライ設定
  sidekiq_options retry: 3

  def perform(user, schedule)
    # Do something later
    # PlanNotificationMailer.with(user: user).on_time.deliver_later

    Rails.logger.info "=" * 80
    Rails.logger.info "🔍 User オブジェクトの詳細確認"
    Rails.logger.info "  user.object_id: #{user.object_id}"
    Rails.logger.info "  user.class: #{user.class}"
    Rails.logger.info "  user.to_gid_param: #{user.to_gid_param}"

    # 念のため DB から再取得
    reloaded_user = User.find(user.id)
    Rails.logger.info "  reloaded_user.object_id: #{reloaded_user.object_id}"
    Rails.logger.info "  reloaded_user.to_gid_param: #{reloaded_user.to_gid_param}"

    # 両者が同じか確認
    Rails.logger.info "  GlobalID が同じ?: #{user.to_gid_param == reloaded_user.to_gid_param}"
    Rails.logger.info "=" * 80

    broadcast_data = {
      type: "web_notification",
      title: notification_title(schedule),
      body: notification_body(schedule),
      schedule_id: schedule.id
    }

    Rails.logger.info "📡 ブロードキャスト送信"
    Rails.logger.info "  送信先 GlobalID: #{user.to_gid_param}"
    Rails.logger.info "  Stream name: notifications:#{user.to_gid_param}"
    Rails.logger.info "  送信データ: #{broadcast_data}"

    NotificationsChannel.broadcast_to(
      reloaded_user,
      broadcast_data
    )

    Rails.logger.info "✅ ブロードキャスト送信完了"
    Rails.logger.info "=" * 80
  end

  def notification_title(schedule)
    case rand(3)
    when 0
      "Daracareだよん"
    when 1
      "Daracareだぜ"
    when 2
      "Daracareダラケア"
    end
  end

  def notification_body(schedule)
    case rand(3)
    when 0
      "やあ！順調かな？
        特別な用事はともかく、普段からやらなきゃいけないことってサボりがちになってくるよね。
        えっ、「ならない。むしろサボる方が信じられない」？あはは、偉いですね……。
        このアプリの制作者はサボりがちだからね。私のようなサボりがちを改善するサポートができていればうれしいね。
        それじゃ、引き続きスケジュールに則って頑張ってね。"
    when 1
      "アラートテストです。急に落ち着かないでくれ"
    when 2
      "ちゃんと予定通りに進んでいるか、わたくしめが監督しに来ましたよ。進捗どうですか？"
    end
  end
end
