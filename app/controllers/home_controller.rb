class HomeController < ApplicationController
  include HomeSearchs
  include ContractData
  include ReportData
  include ReportPoints

  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def graphic
    @current_report = session[:current_report]
    @report_data = session[:report_data]
    @report_points = session[:report_points]
    @contract_points = session[:contract_points]
    @month_year_list = session[:month_year_list]
  end

  def spreadsheet
    begin
      authorize! :spreadsheet, HomeController
    rescue CanCan::AccessDenied
      redirect_to graphic_path
    end

    @month_year_list = session[:month_year_list]
    @current_report = session[:current_report]
    @report_data = session[:report_data]
    @users = session[:all_users]
  end

  def search
    @text = ''
    if session[:month_year_list].nil?
      session[:month_year_list] =
        month_year_list
    end

    init_current_report
    fetch_data_and_points
    @text == 's' ? redirect_to(spreadsheet_path) : redirect_to(graphic_path)
  end

  def logout
    sign_out_and_redirect(current_user)
  end

  def add_contract_data
    add_contract
    refresh_spreadsheet
  end

  def alter_contract_data
    alter_contract
    refresh_spreadsheet
  end

  def delete_contract_data
    report_id = destroy_contract_by_contract_id(params[:delete])
    refresh_spreadsheet
  end

  def refresh_spreadsheet
    fetch_data_and_points
    redirect_to spreadsheet_path
  end

  private

  def init_current_report
    if params[:month_year].nil?
      session[:current_report] = fetch_last_report
    else
      session[:current_report] = fetch_report(params[:month_year].split('/'))
      @text = params[:month_year].split('/')[2]
    end
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

    @days = calculate_month_days
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

  def calculate_month_days
    Time.days_in_month(session[:current_report].month_numb)
  end
end
