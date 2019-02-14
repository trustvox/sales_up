module AccountManager
  class DashboardController < AccountManager::ContractDataController
    before_action except: [:logout] do
      verify_action
      @page_title = init_page_title('AM')
    end

    before_action only: %i[monthly_sales report_AM] do
      init_current_report('AM')
    end

    before_action :authenticate_user!
    skip_before_action :verify_authenticity_token

    def monthly_sales
      data = fetch_contract_by_report_id(@current_report.id)
      data.empty? ? default_contract : fetch_contract_data_points(data)

      @user = fetch_username_by_types('AM', 'GG')

      render_menu('AM')
    end

    def report_AM
      fetch_record_data_points

      render_menu('AM')
    end

    def overview_months_AM
      search_overview_months('AM')

      render_menu('AM')
    end

    def overview_reports_AM
      search_overview_reports('AM')

      render_menu('AM')
    end

    def logout
      sign_out_and_redirect(current_user)
    end

    private

    def verify_action
      verify_authorization(action_name.parameterize.underscore.to_sym,
                         AccountManager::DashboardController)
    end
  end
end
