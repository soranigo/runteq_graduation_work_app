class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    # ユーザーごとの通知チャンネルに接続
    stream_for current_user
    
    # デバッグ用ログ
    # Rails.logger.info "✅ NotificationsChannel subscribed"
    # Rails.logger.info "  User ID: #{current_user.id}"
    # Rails.logger.info "  Stream name: notifications:#{current_user.to_gid_param}"
  end

  def unsubscribed
    # クリーンアップ処理
    Rails.logger.info "NotificationsChannel unsubscribed: User #{current_user.id}"
  end
end
