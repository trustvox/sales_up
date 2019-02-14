module AccountManager
  class ContractDataController < AccountManager::ReportDataController
    include ContractDataPoints

    before_action :authenticate_user!

    def init_contract_data_points
      @contract_data = []
      @contract_point = []
    end

    def fetch_contract_data_points(data)
      init_contract_data_points

      start_contract
      fetch_contract_data(data)
      @contract_point = fetch_contract_points

      @contract_point.unshift([1, 0]) unless @contract_point[0][0] == 1
      @contract_point << [fetch_last_day, @contract_point[-1][1]]

      fetch_report_data_points(@contract_data)
    end

    def default_contract
      init_contract_data_points

      @contract_point << [1, 0]
      @contract_point << [month_days, 0]

      fetch_report_data_points(@contract_data)
    end
  end
end
