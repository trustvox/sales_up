module SalesRepresentative
  class DashboardController < SalesRepresentative::MeetingDataController
    before_action do
      verify_authorization(SalesRepresentative::DashboardController)
    end

    before_action only: %i[monthly_schedules report_sdr] do
      init_current_report(SIDES[1])
    end

    def monthly_schedules
      data = fetch_meeting_by_report_id(@current_report.id)
      data.empty? ? default_meeting : fetch_meeting_data_points(data)

      @users = fetch_username_by_types(SIDES[1], SIDES[0])

      render_menu(SIDES[1])
    end

    def report_sdr
      fetch_record_data_points

      render_menu(SIDES[1])
    end

    def overview_months_sdr
      search_overview_months(SIDES[1])

      render_menu(SIDES[1])
    end

    def overview_reports_sdr
      search_overview_reports(SIDES[1])

      render_menu(SIDES[1])
    end
  end
end
