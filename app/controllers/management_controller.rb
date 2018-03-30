class ManagementController < ApplicationController
  include Manager

  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def view
    session[:spreadsheets] = fetch_report_by_year(fetch_last_year)
    session[:contracts] = fetch_contract_by_report(fetch_last_month,
                                                   fetch_last_year)

    redirect_to manager_path
  end

  def manager; end

  def add_spreadsheet
    @report = Report.new
    fetch_and_reload_spreadsheet(params[:report_name], params[:goal],
                                 params[:month], params[:year])
  end

  def alter_spreadsheet
    request = params[:add_alter].split('/-/')
    id = request[0].split('id:')

    @report = Report.find_by(id: id[1].to_i)
    fetch_and_reload_spreadsheet(request[1], request[2],
                                 request[3], request[4])
  end

  def add_contract
    @contract = Contract.new
    fetch_and_reload_contract(params[:day], params[:store_name],
                              params[:value], params[:username],
                              params[:report])
  end

  def alter_contract
    request = params[:add_alter].split('/-/')
    id = request[0].split('id:')

    @contract = Contract.find_by(id: id[1].to_i)
    fetch_and_reload_contract(request[1], request[2], request[3],
                              request[4], request[5])
  end

  def search_spreadsheet
    session[:spreadsheets] = fetch_report_by_year(params[:year])
    redirect_to manager_path
  end

  def search_contract
    session[:contracts] =
      fetch_contract_by_report(params[:month_year].split('/')[0],
                               params[:month_year].split('/')[1])
    redirect_to manager_path
  end

  def delete_spreadsheet
    year = destroy_report_by_report_id(params[:delete])

    session[:spreadsheets] = fetch_report_by_year(year)
    redirect_to manager_path
  end

  def delete_contract
    report_id = destroy_contract_by_contract_id(params[:delete])

    session[:contracts] = fetch_contract_by_report_id(report_id)
    redirect_to manager_path
  end

  private

  def fetch_and_reload_spreadsheet(name, goal, month, year)
    fetch_report_values(name, goal, month, year)
    @report.save!

    session[:spreadsheets] = fetch_report_by_year(year)
    redirect_to manager_path
  end

  def fetch_report_values(name, goal, month, year)
    @report.report_name = name
    @report.goal = goal

    @report.month_numb = Date.parse(year.to_s + month + '-01').month
    @report.month = month
    @report.year = year
  end

  def fetch_and_reload_contract(day, store_name, value, username, report_id)
    fetch_contract_values(day, store_name, value, username, report_id)
    @contract.save!

    session[:contracts] = fetch_contract_by_report_id(report_id)
    redirect_to manager_path
  end

  def fetch_contract_values(day, store_name, value, username, report_id)
    @contract.day = day
    @contract.store_name = store_name
    @contract.value = value
    @contract.user_id = fetch_user_by_full_name(username)
    @contract.report_id = report_id
  end
end
