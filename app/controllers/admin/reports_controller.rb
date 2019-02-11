module Admin
  class ReportsController < ApplicationController
    before_action :valid_params, only: :create
    before_action :prepare_month_goal_param, only: :update

    def create
      @report.save!

      redirect_to_manager
    end

    def update
      @report = Report.find_by(id: params[:id])
      init_report_goals

      @report.update(report_params)

      redirect_to_manager
    end

    def destroy
      @report = Report.find_by(id: params[:id])
      @report.destroy

      redirect_to_manager
    end

    private

    def redirect_to_manager
      message = @report.errors.messages.map { |msg| msg[1] }
      result = message + [[@report.goal_type]] unless message.empty?
      
      redirect_to controller: 'manager', action: 'manager_settings',
                  'report[year]' => @report.year,
                  'report[side]' => params[:report][:side],
                  notice: result
    end

    def valid_params
      prepare_month_goal_param

      @report = Report.new(report_params)
      init_report_goals

      redirect_to_manager unless @report.valid?
    end

    def prepare_month_goal_param
      prepare_goal_param

      params[:report][:month] =
        Date::MONTHNAMES[params[:report][:month_numb].to_i]

      verify_scheduled_raise unless params[:report][:scheduled_raise].nil?
    end

    def init_report_goals
      @report.individual_goal = @individual_goal[0...-1]
      @report.goal = @goal
    end

    def init_goal_params
      @goal = 0
      @individual_goal = ''
      @which = params[:report][:goal_type]
      @is_SDR = @which == 'SDR'

      params[:report][:scheduled_raise] = 0 if @is_SDR
    end

    def prepare_goal_param
      init_goal_params
      users = fetch_user_by_sub_area('AM')
      users += fetch_user_by_sub_area('SDR') if params[:report][:goal_type] == 'SDR'

      users.each do |user|
        param = params[:report][user.id.to_s]
        goal = param.nil? ? '0' : param.tr(",", ".")
        change_goal_param(goal.to_f, user.id.to_s)
      end
    end

    def change_goal_param(goal, id)
      @individual_goal += id + '-' + goal.to_s + '-'
      @is_SDR ? params[:report][:scheduled_raise] += goal : @goal += goal
    end

    def verify_scheduled_raise
      days = find_business_days_without_report(
        params[:report][:month_numb], params[:report][:year]
      )
      @goal = params[:report][:scheduled_raise].to_f * days
    end

    def report_params
      params.require(:report).permit(:report_name, :goal, :month, :goal_type,
                                     :month_numb, :year, :observation,
                                     :scheduled_raise)
    end
  end
end
