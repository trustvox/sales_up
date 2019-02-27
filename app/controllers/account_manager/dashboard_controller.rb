module AccountManager
  class DashboardController < AccountManager::DealDataController
    before_action except: [:logout] do
      verify_authorization(AccountManager::DashboardController)
    end

    before_action only: %i[monthly_sales monthly_forecast report_am] do
      init_current_report(SIDES[0])
    end

    before_action :authenticate_user!
    skip_before_action :verify_authenticity_token

    def monthly_sales
      data = fetch_contract_by_report_id(@current_report.id)
      data.empty? ? default_contract : fetch_contract_data_points(data)

      @user = fetch_username_by_types(SIDES[0], SIDES[2])

      render_menu(SIDES[0])
    end

    def monthly_forecast
      data = fetch_deal_by_report_id(@current_report.id)
      data.empty? ? default_deal : fetch_deal_data_points(data)

      @user = fetch_username_by_types(SIDES[0], SIDES[2])

      render_menu(SIDES[0])
    end

    def report_am
      fetch_record_data_points

      render_menu(SIDES[0])
    end

    def overview_months_am
      search_overview_months(SIDES[0])

      render_menu(SIDES[0])
    end

    def overview_reports_am
      search_overview_reports(SIDES[0])

      render_menu(SIDES[0])
    end

    def logout
      sign_out_and_redirect(current_user)
    end
  end
end
