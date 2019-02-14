module SalesRepresentative
  class DashboardController < SalesRepresentative::MeetingDataController
    before_action do
      init_view_data
      @page_title = init_page_title('SDR')
    end

    before_action only: %i[monthly_schedules report_SDR] do
      init_current_report('SDR')
    end

    def monthly_schedules
      data = fetch_meeting_by_report_id(@current_report.id)
      data.empty? ? data = default_meeting : fetch_meeting_data_points(data)

      @users = fetch_username_by_types('SDR', 'AM')

      render_menu('SDR')
    end

    def report_SDR
      fetch_record_data_points
      
      render_menu('SDR')
    end

    def overview_months_SDR
      search_overview_months('SDR')

      render_menu('SDR')
    end

    def overview_reports_SDR
      search_overview_reports('SDR')

      render_menu('SDR')
    end

    private

    def init_view_data
      verify_authorization(action_name.parameterize.underscore.to_sym,
                           SalesRepresentative::DashboardController)
    end
  end
end
