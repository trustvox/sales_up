module AccountManager
  class DealDataController < AccountManager::ContractDataController
    include DealDataPoints

    before_action :authenticate_user!

    def init_deal_data_points
      @deal_data = []
      @deal_point = []
    end

    def fetch_deal_data_points(data)
      init_deal_data_points

      start_deal
      fetch_deal_data(data)
      @deal_point = fetch_deal_points

      @deal_point.unshift([1, 0]) unless @deal_point[0][0] == 1

      fetch_report_data_points(@deal_data)
    end

    def default_deal
      init_deal_data_points

      @deal_point << [1, 0]
      @deal_point << [month_days, 0]

      fetch_report_data_points(@deal_data)
    end
  end
end
