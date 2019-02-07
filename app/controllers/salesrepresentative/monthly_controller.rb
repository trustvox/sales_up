module Salesrepresentative
  class MonthlyController < Accountmanager::OverviewController
    include MeetingDataPoints
    include ReportDataPoints
    include RecordDataPoints

    layout 'menu_SDR'
    before_action :authenticate_user!

    def init_month_year_list
      init_current_report

      @month_year_list = all_date_list('SDR')
      @month_year_list.delete(@current_report)
      @month_year_list.unshift(@current_report)
    end

    def search_schedules
      init_month_year_list
      init_search_schedules_data
      fetch_data_and_points
    end

    def init_search_schedules_data
      @report_data = []
      @report_points = []

      @meeting_data = []
      @meeting_points = []
    end

    def init_current_report
      @current_report = if params[:report].nil?
                          fetch_last_report('SDR')
                        else
                          fetch_report(params[:report][:month],
                                       params[:report][:year], 'SDR')
                        end
    end

    def fetch_data_and_points
      result = fetch_meeting_by_report_id(@current_report.id)

      @days = month_days
      if result.empty?
        @meeting_points << [1, 0]
        @meeting_points << [@days, 0]
      else
        fetch_meeting_data_points(result)
      end

      fetch_report_meeting_data_points
    end

    def fetch_meeting_data_points(data)
      start_meeting(data)
      fetch_meeting_data
      fetch_meeting_points

      @meeting_points << [fetch_last_day, @meeting_points[-1][1]]
    end

    def fetch_report_meeting_data_points
      start_data(@meeting_data)
      @report_data = fetch_report_data
      fetch_report_points
    end

    def search_SDR_recods(type)
      init_month_year_list
      init_search_record_data
      fetch_record_data_and_points(type)
    end

    def init_search_record_data
      @record_data = []
      @record_points = []

      @line_names = []
      @users = []
    end

    def fetch_record_data_and_points(type)
      start_record_data(type)
      @record_data = fetch_record_data(type)

      start_record_points
      @record_points = fetch_record_points(type)

      finish_record_search
    end

    def finish_record_search
      @record_points.each_with_index do |record, i|
        @record_points[i] = [[1, 0], [fetch_last_day, 0]] if record.blank?
      end

      @line_names = @record_data.collect { |data| data[0] }
    end
  end
end
