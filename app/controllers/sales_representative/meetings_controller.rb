module SalesRepresentative
  class MeetingsController < ApplicationController
    before_action only: %i[create update] do
      valid_params(action_name)
    end

    def create
      @meetings.user_id = fetch_id_by_username(params[:sdrname])
      @meetings.meeting_for = params[:meeting_for]
      @meetings.save!

      redirect_to_monthly_schedules
    end

    def update
      @meetings = Meeting.find_by(id: params[:id])
      @meetings.update(meeting_params)

      redirect_to_monthly_schedules
    end

    def destroy
      @meetings = Meeting.find_by(id: params[:id])
      @meetings.destroy

      redirect_to_monthly_schedules
    end

    private

    def redirect_to_monthly_schedules(action = nil)
      redirect_to_monthly_method(@meetings.report_id, @meetings.errors, 
                                 'schedules', action)
    end

    def valid_params(action)
      @meetings = Meeting.new(meeting_params)

      redirect_to_monthly_schedules(action) unless @meetings.valid?
    end

    def meeting_params
      params.require(:meeting).permit(:day, :client_name, :scheduled_for,
                                      :report_id, :user_id, :meeting_for)
    end
  end
end
