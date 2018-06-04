class MonthlyController < ApplicationController
  include ContractData
  include ReportData
  include ReportPoints
  include RecordData

  layout 'menu'
  before_action :authenticate_user!

  def init_month_year_list
    init_current_report

    @month_year_list = all_date_list
    @month_year_list.delete(@current_report)
    @month_year_list.unshift(@current_report)
  end

  def search_sales
    init_search_sales_data
    fetch_data_and_points
  end

  def search_recods
    init_search_record_data
    fetch_record_data_and_points
  end

  private

  def init_search_record_data
    @record_data = []
    # @record_points = '[ '
  end

  def fetch_record_data_and_points
    start_record_data(@current_report)
    @record_data = fetch_record_data
  end

  def init_search_sales_data
    @report_data = []
    @report_points = '[ '

    @contract_data = []
    @contract_points = '[ ]'
  end

  def init_current_report
    return @current_report = fetch_last_report if params[:report].nil?
    @current_report =
      fetch_report(params[:report][:month], params[:report][:year])
  end

  def fetch_data_and_points
    result = fetch_contract_by_report_id(@current_report.id)

    @days = month_days
    @days -= 9 if @current_report.month_numb == 12

    fetch_contract_data_points(result) unless result.empty?
    fetch_report_data_points
  end

  def fetch_contract_data_points(data)
    start_contract(@contract_data, @contract_points, data)
    @contract_data = fetch_contract_data
    @contract_points = fetch_contract_points(@days)
  end

  def fetch_report_data_points
    start_data(@days, @current_report, @contract_data)
    @report_data = fetch_report_data

    start_points(@days, @report_data, @report_points)
    @report_points = fetch_report_points
  end
end
