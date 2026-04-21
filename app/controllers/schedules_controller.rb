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
  end

  def notifications
    @user = current_user
    PlanNotificationMailer.with(user: @user).on_time.deliver_later
  end

  private

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
    ending_time = convert_time_to_seconds(get_date(plan.ending_day_of_week, plan.ending_time_before_type_conversion))
    starting_time = convert_time_to_seconds(get_date(plan.starting_day_of_week, plan.starting_time_before_type_conversion))
    ending_time = ending_time + 7 * 24 * 60 * 60 if ending_time < starting_time
    (ending_time - starting_time) / (30 * 60)
  end

  def add_to_plan_ids_hash(plan_hash, plan_ids_hash, t)
    # 下記のstarting_time_before_type_conversionを書き換える。get_dataを使用してこの予定の曜日を取得できるようにすること。
    time = get_date(plan_hash[1].starting_day_of_week, plan_hash[1].starting_time_before_type_conversion)
    add_time_half_hour_each = time + t * 30 * 60
    plan_ids_hash[[ (convert_time_to_seconds(add_time_half_hour_each) / (24 * 60 * 60)).round, add_time_half_hour_each.strftime("%H:%M") ]] = plan_hash[1]
    # add_time_half_hour_eachの曜日を数字に変換して使いたいが、
    # add_time_half_hour_eachはデータベースに保存しない変数のため
    # starting_day_of_week_before_type_castで値を取得できない上にenumも使えない
    # enumで定義したものを他の変数にも使いたいが……
  end

  def convert_time_to_seconds(time)
    ((time.strftime("%k").to_i + DAYS_OF_WEEK[time.strftime("%a")] * 24) * 60 + time.strftime("%M").to_i) * 60
  end

  def get_date(day_of_week, time)
    Time.zone.local(@time.strftime("%Y").to_i,
                    @time.strftime("%m").to_i,
                    DAYS_OF_WEEK[day_of_week],
                    time.strftime("%H").to_i,
                    time.strftime("%M").to_i,
                    0)
  end
end
