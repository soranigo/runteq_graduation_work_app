class ApplicationController < ActionController::Base
  before_action :require_login

  # Action Cable 用のセッション設定
  before_action :set_action_cable_identifier

  def time_define
    @time = Time.new(2026, 2, 1, 0, 0, 0)
  end

  def set_action_cable_identifier
    if logged_in?
      cookies.signed[:user_id] = current_user.id
    end
  end

  def not_authenticated
    redirect_to login_path, alert: "ログインしてください"
  end
end
