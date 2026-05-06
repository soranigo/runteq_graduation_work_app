class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    # ユーザーごとの通知チャンネルに接続
    stream_from "notifications_#{current_user.id}"
  end

  def unsubscribed
    # クリーンアップ処理
  end
end