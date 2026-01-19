class PlansController < ApplicationController
  before_action :prohibit_interference_with_others, only: %i[ create edit update destroy ]
  before_action :set_schedule
  before_action :set_plan, only: %i[ edit update destroy ]
  before_action :set_url_with_get_method, only: %i[ new create ]
  before_action :set_url_with_put_method, only: %i[ edit update ]

  def new
    @plan = Plan.new(starting_day_of_week: params[:starting_day_of_week].to_i, starting_time_before_type_conversion: params[:starting_time_before_type_conversion])
  end

  def create
    @plan = Plan.new(plan_params)
    @plan.starting_time = @plan.starting_time_before_type_conversion.strftime("%H:%M")
    @plan.ending_time = @plan.ending_time_before_type_conversion.strftime("%H:%M")
    if @plan.save
      define_alert_timings(@plan)
      redirect_to schedule_path(@plan.schedule), notice: "#{@plan.name}を作成しました"
    else
      flash.now[:danger] = "プランを作成出来ませんでした"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @url = schedule_plan_path
    @method = :put
    @plan = Plan.find_by(id: params[:id], schedule_id: params[:schedule_id])
  end

  def update
    @plan = Plan.find_by(id: params[:id], schedule_id: params[:schedule_id])
    @plan_substitute = Plan.new(plan_params)
    plan_param = plan_params
    plan_param[:starting_time] = @plan_substitute.starting_time_before_type_conversion.strftime("%H:%M")
    plan_param[:ending_time] = @plan_substitute.ending_time_before_type_conversion.strftime("%H:%M")
    if @plan.update(plan_param)
      define_alert_timings(@plan)
      redirect_to schedule_path(@plan.schedule), notice: "#{@plan.name}を更新しました"
    else
      flash.now[:danger] = "プランを更新出来ませんでした"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @plan = Plan.find_by(id: params[:id], schedule_id: params[:schedule_id])
    return_pass = schedule_path(@plan.schedule)
    plan_name = @plan.name
    @plan.destroy
    redirect_to return_pass, notice: "プラン「#{plan_name}」を削除しました"
  end

  private

  def plan_params
    params.require(:plan).permit(:name, :starting_day_of_week, :starting_time_before_type_conversion, :ending_day_of_week, :ending_time_before_type_conversion).merge(user_id: current_user.id, schedule_id: params[:schedule_id])
  end

  def set_schedule
    @schedule = Schedule.find(params[:schedule_id])
  end

  def set_plan
    @plan = @schedule.plans.find(params[:id])
  end

  def set_url_with_get_method
    @url = schedule_plans_path(@schedule)
    @method = :post
  end

  def set_url_with_put_method
    @url = schedule_plans_path(@schedule)
    @method = :put
  end

  def define_alert_timings(plan)
    # 下記の機能を、キュー削除機能に修正する必要がある
    # if AlertTiming.find_by(plan_id: plan.id)
    # AlertTiming.where(plan_id: plan.id).destroy_all
    # end

    starting_time_convert_minutes = convert_time_to_minutes(plan.starting_time)
    ending_time_convert_minutes = convert_time_to_minutes(plan.ending_time)

    today_day_of_week = Plan.current_day_of_week_value
    current_time = Plan.current_time_value
    current_time_convert_minutes = convert_time_to_minutes(current_time)

    days_later = how_many_days_later(plan, starting_time_convert_minutes, today_day_of_week, current_time_convert_minutes)
    time_later = how_many_time_later(plan, starting_time_convert_minutes, today_day_of_week, current_time_convert_minutes)
    counts = loop_count(plan, starting_time_convert_minutes, ending_time_convert_minutes)
    alerts_later(counts, days_later, time_later, current_user)
  end

  def convert_time_to_minutes(time)
    separate_hour_minutes = time.split(":")
    separate_hour_minutes[0].to_i * 60 + separate_hour_minutes[1].to_i
  end

  def loop_count(plan, starting_time_convert_minutes, ending_time_convert_minutes)
    time_range = plan.ending_day_of_week.to_i * 24 * 60 + ending_time_convert_minutes - (plan.starting_day_of_week.to_i * 24 * 60 + starting_time_convert_minutes)
    if time_range == 30
      3
    elsif time_range <= 60
      5
    else
      5 + (time_range - 60) / 30
    end
  end

  def alerts_later(counts, days_later, time_later, user)
    counts.times do |count|
      minutes = difine_minutes(count) + time_later
      PeriodicNotificationJob.set(wait: days_later.days + minutes.minute).perform_later(user)
    end
  end

  def how_many_days_later(plan, starting_time_convert_minutes, today_day_of_week, current_time_convert_minutes)
    if determine_if_day_of_week_passed(plan, starting_time_convert_minutes, today_day_of_week, current_time_convert_minutes)
      plan.starting_day_of_week_before_type_cast - today_day_of_week + 6
    else
      plan.starting_day_of_week_before_type_cast - today_day_of_week
    end
  end

  def how_many_time_later(plan, starting_time_convert_minutes, today_day_of_week, current_time_convert_minutes)
    if determine_if_day_of_week_passed(plan, starting_time_convert_minutes, today_day_of_week, current_time_convert_minutes)
      starting_time_convert_minutes - current_time_convert_minutes + 24 * 60
    else
      starting_time_convert_minutes - current_time_convert_minutes
    end
  end

  def determine_if_day_of_week_passed(plan, starting_time_convert_minutes, today_day_of_week, current_time_convert_minutes)
    difference_in_days_of_the_week = plan.starting_day_of_week_before_type_cast - today_day_of_week.to_i
    if difference_in_days_of_the_week > 0
      false
    elsif difference_in_days_of_the_week < 0
      true
    elsif difference_in_days_of_the_week == 0
      if starting_time_convert_minutes > current_time_convert_minutes
        false
      else
        true
      end
    end
  end

  def difine_minutes(count)
    if count == 0
      minutes = 3
    elsif count == 1
      minutes = 10
    elsif count <= 3
      minutes = 20 * (count - 1)
    else
      minutes = 30 * (count - 2)
    end
    minutes
  end

  def prohibit_interference_with_others
    @schedule = Schedule.find(params[:schedule_id])
    if @schedule.user != current_user
      redirect_to schedules_path, notice: "他のユーザーへの干渉は許しません。"
    end
  end
end
