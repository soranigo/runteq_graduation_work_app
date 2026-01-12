class PlansController < ApplicationController
  def new
    @plan = Plan.new(starting_day_of_week: params[:starting_day_of_week].to_i, starting_time_before_type_conversion: params[:starting_time_before_type_conversion])
  end

  def create
    @plan = Plan.new(plan_params)
    @plan.starting_time = @plan.starting_time_before_type_conversion.strftime("%H:%M").to_s
    @plan.ending_time = @plan.ending_time_before_type_conversion.strftime("%H:%M").to_s
    if @plan.save
      redirect_to schedule_path(@plan.schedule), notice: "#{@plan.name}を作成しました"
    else
      flash.now[:danger] = "プランを作成出来ませんでした"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @plan = Plan.find(params[:id])
  end

  private

  def plan_params
    params.require(:plan).permit(:name, :starting_day_of_week, :starting_time_before_type_conversion, :ending_day_of_week, :ending_time_before_type_conversion).merge(user_id: current_user.id, schedule_id: params[:schedule_id])
  end
end
