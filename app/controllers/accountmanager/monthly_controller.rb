module Accountmanager
  class MonthlyController < Accountmanager::OverviewController
    include ContractDataPoints
    include ReportDataPoints
    include RecordDataPoints

    before_action :authenticate_user!

    def init_month_year_list
      init_current_report

      @month_year_list = all_date_list('AM')
      @month_year_list.delete(@current_report)
      @month_year_list.unshift(@current_report)
    end

    def search_AM
      init_month_year_list
      init_search_AM_data
      fetch_data_and_points
    end

    def search_recods(type)
      init_month_year_list
      init_search_record_data
      fetch_record_data_and_points(type)
    end

    private

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

    def init_search_AM_data
      @report_data = []
      @report_points = []

      @contract_data = []
      @contract_points = []
    end

    def init_current_report
      @current_report = if params[:report].nil?
                          fetch_last_report('AM')
                        else
                          fetch_report(params[:report][:month],
                                       params[:report][:year], 'AM')
                        end
    end

    def fetch_data_and_points
      result = fetch_contract_by_report_id(@current_report.id)
      @days = month_days

      if result.empty?
        @contract_points << [1, 0]
        @contract_points << [@days, 0]
      else
        fetch_contract_data_points(result)
      end

      fetch_report_AM_data_points
    end

    def fetch_contract_data_points(data)
      start_contract(data)
      fetch_contract_data
      fetch_contract_points

      @contract_points << [fetch_last_day, @contract_points[-1][1]]
    end

    def fetch_report_AM_data_points
      start_data(@contract_data)
      @report_data = fetch_report_data
      fetch_report_points
    end
  end
end
