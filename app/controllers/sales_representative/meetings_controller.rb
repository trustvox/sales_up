module SalesRepresentative
  class MeetingsController < ApplicationController
    before_action only: %i[create update] do
      valid_params(action_name)
    end

    def create
      @meeting.user_id = fetch_id_by_username(params[:SDRname])
      @meeting.meeting_for = params[:meeting_for]
      @meeting.save!

      redirect_to_monthly_schedules
    end

    def update
      @meeting = Meeting.find_by(id: params[:id])
      @meeting.update(meeting_params)

      redirect_to_monthly_schedules
    end

    def destroy
      @meeting = Meeting.find_by(id: params[:id])
      @meeting.destroy

      redirect_to_monthly_schedules
    end

    private

    def redirect_to_monthly_schedules(action = nil)
      report = fetch_report_by_id(@meeting.report_id)
      message = @meeting.errors.messages.map { |msg| msg[1] }

      redirect_to controller: 'dashboard', action: 'monthly_schedules',
                  'report[month]' => report.month, 'report[year]' => report.year,
                  notice: message + [[action]]
    end

    def valid_params(action)
      @meeting = Meeting.new(meeting_params)
      
      redirect_to_monthly_schedules(action) unless @meeting.valid?
    end

    def meeting_params
      params.require(:meeting).permit(:day, :client_name, :scheduled_for,
                                      :report_id, :user_id, :meeting_for)
    end
  end
end
