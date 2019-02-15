module AccountManager
  class ReportDataController < AccountManager::RecordDataController
    include ReportDataPoints

    before_action :authenticate_user!

    def init_report_data_points
      @report_data = []
      @report_points = []
    end

    def fetch_report_data_points(data)
      init_report_data_points
      start_data

      @report_data = fetch_report_data(data)
      fetch_report_points
    end
  end
end
