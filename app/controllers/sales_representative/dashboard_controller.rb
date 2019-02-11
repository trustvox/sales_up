module SalesRepresentative
  class DashboardController < SalesRepresentative::MonthlyController
    before_action :init_view_data, only: %i[monthly_schedules overview_months_SDR
                                            overview_reports_SDR report_SDR]

    include GraphicHelper

    def monthly_schedules
      search_schedules

      @day_text = day_text_generator
      @wday_text = wday_text_generator
      @users = fetch_username_by_types('SDR', 'AM')

      render_menu('SDR')
    end

    def report_SDR
      search_SDR_recods('SDR')

      @graphic_text = day_text_generator
      @wday_text = wday_text_generator

      render_menu('SDR')
    end

    def overview_months_SDR
      search_overview_months('SDR')

      @month_text = month_text_generator('SDR')
      render_menu('SDR')
    end

    def overview_reports_SDR
      search_overview_reports('SDR')

      init_overview_options_list('SDR')
      verify_options unless params[:report].nil?

      @month_text = month_text_generator('SDR')
      render_menu('SDR')
    end

    private

    def init_view_data
      verify_authorization(action_name.parameterize.underscore.to_sym,
                           SalesRepresentative::DashboardController)

      @page_title = [t('menu.' + action_name), t('menu.sales_side') + '-' +
        t('menu.SDR_side'), 'SDR']
      @report = Report.new
      @meeting = Meeting.new
      @observation = ReportObservation.new
    end
  end
end
