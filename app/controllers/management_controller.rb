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
    request = params[:delete].split('/')
    destroy_report_by_month_year(request[0], request[1])

    session[:spreadsheets] = fetch_report_by_year(request[1].to_i)
    redirect_to manager_path
  end

  def delete_contract
    request = params[:delete].split('/')
    destroy_contract_by_day_report(request[0], request[1], request[2])

    session[:contracts] = fetch_contract_by_report(request[1], request[2])
    redirect_to manager_path
  end
end
