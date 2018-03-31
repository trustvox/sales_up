class HomeController < ApplicationController
  include HomeSearchs
  include ContractData
  include ReportData
  include ReportPoints

  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def graphic
    @current_report = session[:current_report]
    @report_points = session[:report_points]
    @contract_points = session[:contract_points]
  end

  def spreadsheet
    begin
      authorize! :spreadsheet, HomeController
    rescue CanCan::AccessDenied
      redirect_to graphic_path
    end

    @current_report = session[:current_report]
    @report_data = session[:report_data]
  end

  def search
    init_current_report
    fetch_data_and_points
    if params[:where] == 'spreadsheet'
      redirect_to(spreadsheet_path)
    else
      redirect_to(graphic_path)
    end
  end

  def logout
    sign_out_and_redirect(current_user)
  end

  private

  def init_current_report
    session[:current_report] = if params[:month_year].nil?
                                 fetch_last_report
                               else
                                 fetch_report(params[:month_year].split('/'))
                               end
  end

  def clear_session_data
    session[:report_data] = []
    session[:report_points] = '[ '

    session[:contract_data] = []
    session[:contract_points] = '[ ]'
  end

  def fetch_data_and_points
    clear_session_data
    result = fetch_contract_by_report_id(session[:current_report].id)

    fetch_contract_data_points(result) unless result.empty?
    fetch_report_data_points
  end

  def fetch_report_data_points
    days = calculate_month_days
    fetch_data(days)
    fetch_points(days)
  end

  def fetch_data(days)
    start_data(days, session[:current_report], session[:contract_data])
    session[:report_data] = fetch_report_data
  end

  def fetch_points(days)
    start_points(days, session[:report_data], session[:report_points])
    session[:report_points] = fetch_report_points
  end

  def fetch_contract_data_points(data)
    start_contract(session[:contract_data], session[:contract_points], data)
    session[:contract_data] = fetch_contract_data
    session[:contract_points] = fetch_contract_points
  end

  def calculate_month_days
    Time.days_in_month(session[:current_report].month_numb)
  end
end
