class SchedulesController < ApplicationController
  before_action :time_define, only: %i[ new create show ]
  def index
    @schedules = current_user.schedules.all
  end

  def new
    @schedule = Schedule.new
  end

  def create
    @schedule = Schedule.new(schedule_params)
    if @schedule.save
      redirect_to schedule_path(@schedule), success: "#{@schedule.name}を作成しました"
    else
      flash.now[:danger] = "スケジュール表を作成出来ませんでした"
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  private

  def time_define
    @time = Time.new(2026, 1, 5, 0, 0, 0, "+09:00")
  end

  def schedule_params
    params.require(:schedule).permit(:name).merge(user_id: current_user.id)
  end
end
