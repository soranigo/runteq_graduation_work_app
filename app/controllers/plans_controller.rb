class PlansController < ApplicationController
  def new
    @url = schedule_plans_path
    @method = :post
    @plan = Plan.new(starting_day_of_week: params[:starting_day_of_week].to_i, starting_time_before_type_conversion: params[:starting_time_before_type_conversion])
  end

  def create
    @plan = Plan.new(plan_params)
    @method = :put
    @plan.starting_time = @plan.starting_time_before_type_conversion.strftime("%H:%M").to_s
    @plan.ending_time = @plan.ending_time_before_type_conversion.strftime("%H:%M").to_s
    if @plan.save
      redirect_to schedule_path(@plan.schedule), notice: "#{@plan.name}を作成しました"
    else
      flash.now[:danger] = "プランを作成出来ませんでした"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @url = schedule_plan_path
    @plan = Plan.find_by(id: params[:id], schedule_id: params[:schedule_id])
  end

  def update
    @plan = Plan.find_by(id: params[:id], schedule_id: params[:schedule_id])
    if @plan.update(plan_params)
      redirect_to schedule_path(@plan.schedule), notice: "#{@plan.name}を更新しました"
    else
      flash.now[:danger] = "プランを更新出来ませんでした"
      render :new, status: :unprocessable_entity
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
end
