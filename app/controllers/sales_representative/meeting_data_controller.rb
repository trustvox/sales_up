module SalesRepresentative
  class MeetingDataController < AccountManager::ReportDataController
    include MeetingDataPoints

    layout 'menu_sdr'
    before_action :authenticate_user!

    def init_meeting_data_points
      @meeting_data = []
      @meeting_points = []
    end

    def fetch_meeting_data_points(data)
      init_meeting_data_points

      start_meeting(data)
      fetch_meeting_data
      fetch_meeting_points

      @meeting_points << [fetch_last_day, @meeting_points[-1][1]]
      fetch_report_data_points(@meeting_data)
    end

    def default_meeting
      init_meeting_data_points
      days = month_days

      @meeting_points << [1, 0]
      @meeting_points << [days, 0]

      fetch_report_data_points(@meeting_data)
    end
  end
end
