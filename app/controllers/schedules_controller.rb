class SchedulesController < ApplicationController
  before_action :prohibit_interference_with_others, only: %i[ show ]
  before_action :time_define, only: %i[ new create show ]

  include DayOfWeek

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
                                              plan.starting_time
                                            ] }
    @plan_ids_hash = {}
    @plans_hash.each do |plan_hash|
      # (((plan_hash[1].ending_time_before_type_conversion - plan_hash[1].starting_time_before_type_conversion) / 1800).round).times do |t|
      time_slot_number = time_slot_number_calculation(plan_hash[1])
      time_slot_number.round.times do |t|
        add_to_plan_ids_hash(plan_hash, @plan_ids_hash, t)
      end
    end
    binding.pry
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
    end_con = convert_time_to_seconds(plan.ending_day_of_week_before_type_cast, plan.ending_time_before_type_conversion)
    start_con = convert_time_to_seconds(plan.starting_day_of_week_before_type_cast, plan.starting_time_before_type_conversion)
    ending_time = end_con + plan.ending_day_of_week_before_type_cast * 24 * 60 * 60
    starting_time = start_con + plan.starting_day_of_week_before_type_cast * 24 * 60 * 60
    binding.pry
    (ending_time - starting_time) / (30 * 60)
  end

  def add_to_plan_ids_hash(plan_hash, plan_ids_hash, t)
    add_time_half_hour_each = plan_hash[1].starting_time_before_type_conversion + t * 30 * 60
    plan_ids_hash[[ convert_time_to_seconds(DAYS_OF_WEEK[add_time_half_hour_each.strftime("%a")], add_time_half_hour_each) / (24 * 60 * 60), add_time_half_hour_each.strftime("%H:%M") ]] = plan_hash[1].id
    # add_time_half_hour_eachの曜日を数字に変換して使いたいが、
    # add_time_half_hour_eachはデータベースに保存しない変数のため
    # starting_day_of_week_before_type_castで値を取得できない上にenumも使えない
    # enumで定義したものを他の変数にも使いたいが……
  end

  def convert_time_to_seconds(day_of_week, time)
    ((time.strftime("%k").to_i + day_of_week.to_i * 24) * 60 + time.strftime("%M").to_i) * 60
  end
end
