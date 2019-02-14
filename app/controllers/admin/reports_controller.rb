module Admin
  class ReportsController < ApplicationController
    def create
      @reports = Report.new(report_params)

      valid_params
      @reports.save!

      redirect_to_manager
    end

    def update
      @reports = Report.find_by(id: params[:id])

      valid_params
      @reports.update(report_params)

      redirect_to_manager
    end

    def destroy
      @reports = Report.find_by(id: params[:id])
      @reports.destroy

      redirect_to_manager
    end

    private

    def redirect_to_manager
      message = @reports.errors.messages.map { |msg| msg[1] }
      result = message + [[@reports.goal_type]] unless message.empty?
      
      redirect_to controller: 'manager', action: 'manager_settings',
                  'report[year]' => @reports.year,
                  'report[side]' => params[:report][:side],
                  notice: result
    end

    def valid_params
      @reports.goal = 0
      @reports.individual_goal = ''

      prepare_month_goal_param
      @reports.individual_goal = @reports.individual_goal[0...-1]

      redirect_to_manager unless @reports.valid?
    end

    def prepare_month_goal_param
      prepare_goal_param

      @reports.month = Date::MONTHNAMES[params[:report][:month_numb].to_i]

      verify_scheduled_raise unless @reports.scheduled_raise.zero?
    end

    def prepare_goal_param
      is_SDR = params[:report][:goal_type] == 'SDR'
      @reports.scheduled_raise = 0

      init_users_data_for_report.each do |user|
        param = params[:report][user.id.to_s]
        user_goal = param.nil? ? '0' : param.tr(",", ".")

        change_goal_param(user_goal.to_f, is_SDR)
        change_individual_goal_param(user_goal.to_f, user.id.to_s)
      end
    end

    def init_users_data_for_report
      users = fetch_user_by_sub_area('AM')
      users += fetch_user_by_sub_area('SDR') if params[:report][:goal_type] == 'SDR'

      users
    end

    def change_goal_param(goal, is_SDR)
      is_SDR ? @reports.scheduled_raise += goal : @reports.goal += goal
    end

    def change_individual_goal_param(goal, id)
      @reports.individual_goal += id + '-' + goal.to_s + '-'
    end

    def verify_scheduled_raise
      days = find_business_days_without_report(
        params[:report][:month_numb], params[:report][:year]
      )
      @reports.goal = @reports.scheduled_raise.to_f * days
    end

    def report_params
      params.require(:report).permit(:report_name, :goal, :month, :goal_type,
                                     :month_numb, :year, :observation,
                                     :scheduled_raise)
    end
  end
end
