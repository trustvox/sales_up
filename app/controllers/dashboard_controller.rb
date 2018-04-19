class DashboardController < ApplicationController
  include ContractData
  include ReportData
  include ReportPoints
  include OverviewPoints

  layout 'menu'
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def render_menu
    render layout: 'menu'
  end

  def search
    @text = ''
    if session[:month_year_list].nil?
      session[:month_year_list] = month_year_list
    end

    init_current_report
    fetch_data_and_points

    if @text == 'o'
      search_overview_data
    else
      @text == 's' ? redirect_to(spreadsheet_path) : redirect_to(graphic_path)
    end
  end

  def search_overview_data
    init_overview_data(params[:first_date], params[:last_date])
    overview_data
    redirect_to overview_path
  end

  def month_year_list
    list = []
    fetch_all_years.each do |year|
      fetch_reports_by_year(year).each do |report|
        list << report
      end
    end
    list
  end

  def init_current_report
    if params[:month_year].nil?
      @text = 'o'
      return session[:current_report] = fetch_last_report
    end
    session[:current_report] = fetch_report(params[:month_year].split('/'))
    @text = params[:month_year].split('/')[2]
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
