module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      logger.add_tags "ActionCable", current_user.email
    end

    private

    def find_verified_user
      # cookies から user_id を取得
      # デバッグ用ログを追加
      Rails.logger.info "🔍 Cookie の内容を確認:"
      Rails.logger.info "  encrypted[:user_id]: #{cookies.encrypted[:user_id]}"
      Rails.logger.info "  signed[:user_id]: #{cookies.signed[:user_id]}"
      Rails.logger.info "  通常の[:user_id]: #{cookies[:user_id]}"

      # まず encrypted を試す
      user_id = cookies.encrypted[:user_id]

      # encrypted がなければ signed を試す
      user_id ||= cookies.signed[:user_id]

      if user_id && (verified_user = User.find_by(id: user_id))
        Rails.logger.info "✅ ユーザー認証成功: #{verified_user.email}"
        verified_user
      else
        Rails.logger.error "❌ ユーザー認証失敗: user_id=#{user_id}"
        reject_unauthorized_connection
      end
    end
  end
end
