class ApplicationController < ActionController::Base
  before_action :require_login

  def time_define
    @time = Time.new(2026, 2, 1, 0, 0, 0)
  end
end
