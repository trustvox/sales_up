class DashboardController < ApplicationController
  include ContractData
  include ReportData
  include ReportPoints
  include OverviewPoints

  layout 'menu'
  before_action :authenticate_user!
  before_action :init_overview_search_data, only: [:search_overview_data]
  skip_before_action :verify_authenticity_token

  def init_search_data
    @current_report = nil
    @month_year_list = []

    @report_data = []
    @report_points = '[ '

    @contract_data = []
    @contract_points = '[ ]'
  end

  def init_overview_search_data
    @goal_points = '[ '
    @sum_points = '[ '
    @months_between = []

    @first_list = []
    @last_list = []

    @first_report = nil
    @last_report = nil
  end

  def search
    init_search_data
    init_current_report
    init_month_year_list
    fetch_data_and_points
  end

  def init_current_report
    return @current_report = fetch_last_report if params[:report].nil?
    @current_report =
      fetch_report(params[:report][:month], params[:report][:year])
  end

  def init_month_year_list
    @month_year_list = all_date_list
    @month_year_list.delete(@current_report)
    @month_year_list.unshift(@current_report)
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

  def which_page(page_letter)
    params[:report][:report_name] == page_letter
  end

  def start_overview_search
    return init_overview_data(nil, nil) if params[:report].nil?
    init_overview_data(params[:report][:month].split('/'),
                       params[:report][:year].split('/'))
  end

  def search_overview_data
    start_overview_search
    overview_data
    selection_list

    adjust_list(@last_list, @last_report)
  end

  def selection_list
    create_lists(@first_list)
    create_lists(@last_list)
    adjust_list(@first_list, @first_report)
  end

  def create_lists(date_list)
    all_date_list.map { |m| date_list << (m.month + '/' + m.year.to_s) }
  end

  def adjust_list(date_list, report)
    date_list.delete(report.month + '/' + report.year.to_s)
    date_list.unshift(report.month + '/' + report.year.to_s)
  end
end
