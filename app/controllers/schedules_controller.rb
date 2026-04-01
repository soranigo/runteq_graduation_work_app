class SchedulesController < ApplicationController
  before_action :prohibit_interference_with_others, only: %i[ show ]
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

  def show
    @schedule = Schedule.find(params[:id])
    @plans = @schedule.plans.all
    @plans_hash = @plans.index_by { |plan| [
                                              plan.starting_day_of_week_before_type_cast,
                                              plan.starting_time,
                                            ] }
    @plan_ids_hash = {}
    @plans_hash.each do |plan_hash|
      (((plan_hash[1].ending_time_before_type_conversion - plan_hash[1].starting_time_before_type_conversion) / 1800).round - 1).times do |t|
        @plan_ids_hash[ [ plan_hash[1].starting_day_of_week_before_type_cast, (plan_hash[1].starting_time_before_type_conversion + (t + 1) * 30 * 60).strftime("%H:%M") ] ] = plan_hash[1]
      end
    end
  end

  def notifications
    @user = current_user
    PlanNotificationMailer.with(user: @user).on_time.deliver_later
  end

  private

  def time_define
    @time = Time.new(2026, 1, 4, 0, 0, 0)
  end

  def schedule_params
    params.require(:schedule).permit(:name).merge(user_id: current_user.id)
  end

  def prohibit_interference_with_others
    @schedule = Schedule.find(params[:id])
    if @schedule.user != current_user
      redirect_to schedules_path, notice: "他のユーザーへの干渉は許しません。"
    end
  end

  def time_slot_number_calculation(plan)
    ending_time = plan.ending_day_of_week * 24 * 60 * 60 + plan.ending_time_before_type_conversion
    starting_time = plan.starting_day_of_week * 24 * 60 * 60 + plan.starting_time_before_type_conversion
    return ending_time - starting_time
  end
end
