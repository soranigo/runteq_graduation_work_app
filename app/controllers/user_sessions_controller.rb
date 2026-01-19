class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[ new create ]
  before_action :do_not_login_current_user_exist, only: %i[ new create ]

  def new; end

  def create
    @user = login(params[:email], params[:password])

    if @user
      redirect_to schedules_path, notice: "Login successful"
    else
      flash.now[:alert] = "Login failed"

      render action: "new", status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to login_path, notice: "Logged out!", status: :see_other
  end

  private

  def do_not_login_current_user_exist
    if current_user
      redirect_to schedules_path
    end
  end
end
