class DashboardController < ApplicationController
  include ContractData
  include ReportData
  include ReportPoints
  include OverviewPoints

  layout 'menu'
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def search
    init_current_report
    init_month_year_list
    fetch_data_and_points
    redirect_user
  end

  def search_overview_data
    start_overview_search
    overview_data
    selection_list

    adjust_list(session[:last_list], session[:last_report])
    redirect_to overview_path
  end

  def start_overview_search
    return init_overview_data(nil, nil) if params[:report].nil?
    init_overview_data(params[:report][:month].split('/'),
                       params[:report][:year].split('/'))
  end

  def selection_list
    create_lists(session[:first_list])
    create_lists(session[:last_list])
    adjust_list(session[:first_list], session[:first_report])
  end

  def create_lists(date_list)
    all_date_list.map { |m| date_list << (m.month + '/' + m.year.to_s) }
  end

  def adjust_list(date_list, report)
    date_list.delete(report.month + '/' + report.year.to_s)
    date_list.unshift(report.month + '/' + report.year.to_s)
  end

  def redirect_user
    if params[:report].nil? || which_page('o')
      search_overview_data
    elsif which_page('s')
      redirect_to(spreadsheet_path)
    else
      redirect_to(graphic_path)
    end
  end

  def which_page(page_letter)
    params[:report][:report_name] == page_letter
  end

  def init_month_year_list
    session[:month_year_list] = all_date_list
    session[:month_year_list].delete(session[:current_report])
    session[:month_year_list].unshift(session[:current_report])
  end

  def init_current_report
    return session[:current_report] = fetch_last_report if params[:report].nil?
    session[:current_report] =
      fetch_report(params[:report][:month], params[:report][:year])
  end

  def clear_session_data
    session[:all_users] = fetch_username_by_priority
    session[:report_data] = []
    session[:report_points] = '[ '

    session[:contract_data] = []
    session[:contract_points] = '[ ]'
  end

  def fetch_data_and_points
    clear_session_data
    result = fetch_contract_by_report_id(session[:current_report].id)

    @days = month_days
    @days -= 9 if session[:current_report].month_numb == 12

    fetch_contract_data_points(result) unless result.empty?
    fetch_report_data_points
  end

  def fetch_report_data_points
    fetch_data
    fetch_points
  end

  def fetch_data
    start_data(@days, session[:current_report], session[:contract_data])
    session[:report_data] = fetch_report_data
  end

  def fetch_points
    start_points(@days, session[:report_data], session[:report_points])
    session[:report_points] = fetch_report_points
  end

  def fetch_contract_data_points(data)
    start_contract(session[:contract_data], session[:contract_points], data)
    session[:contract_data] = fetch_contract_data
    session[:contract_points] = fetch_contract_points(@days)
  end
end
