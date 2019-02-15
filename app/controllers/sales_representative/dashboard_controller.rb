module SalesRepresentative
  class DashboardController < SalesRepresentative::MeetingDataController
    before_action do
      init_view_data
      @page_title = init_page_title('sdr')
    end

    before_action only: %i[monthly_schedules report_sdr] do
      init_current_report('sdr')
    end

    def monthly_schedules
      data = fetch_meeting_by_report_id(@current_report.id)
      data.empty? ? data = default_meeting : fetch_meeting_data_points(data)

      @users = fetch_username_by_types('sdr', 'am')

      render_menu('sdr')
    end

    def report_sdr
      fetch_record_data_points
      
      render_menu('sdr')
    end

    def overview_months_sdr
      search_overview_months('sdr')

      render_menu('sdr')
    end

    def overview_reports_sdr
      search_overview_reports('sdr')

      render_menu('sdr')
    end

    private

    def init_view_data
      verify_authorization(action_name.parameterize.underscore.to_sym,
                           SalesRepresentative::DashboardController)
    end
  end
end
