module Accountmanager
  class DashboardController < Accountmanager::MonthlyController
    before_action :init_view_data,
                  only: %i[monthly_sales overview_reports_AM
                           overview_months_AM report_AM]

    before_action :authenticate_user!
    skip_before_action :verify_authenticity_token

    include GraphicHelper

    def monthly_sales
      search_AM

      @day_text = day_text_generator
      @wday_text = wday_text_generator
      @users = fetch_username_by_types('AM', 'GG')

      render_menu('AM')
    end

    def report_AM
      search_recods('AM')

      @graphic_text = day_text_generator
      @wday_text = wday_text_generator

      render_menu('AM')
    end

    def overview_months_AM
      search_overview_months('AM')

      @month_text = month_text_generator('AM')
      render_menu('AM')
    end

    def overview_reports_AM
      search_overview_reports('AM')

      init_overview_options_list('AM')
      verify_options unless params[:report].nil?

      @month_text = month_text_generator('AM')
      render_menu('AM')
    end

    def logout
      sign_out_and_redirect(current_user)
    end

    private

    def init_view_data
      verify_authorization(action_name.parameterize.underscore.to_sym,
                           Accountmanager::DashboardController)
      @page_title = [t('menu.' + action_name), t('menu.sales_side') + '-' +
        t('menu.AM_side'), 'AM']
      fetch_view_form_variables
    end

    def fetch_view_form_variables
      @observation = ReportObservation.new
      @contract = Contract.new
      @report = Report.new
      @user = User.new
    end
  end
end
