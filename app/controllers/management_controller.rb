class ManagementController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  $spreadsheet_group = []
  $contract_group = []

  def view
    restart_spreadsheet_view
    restart_contract_view
    redirect_to manager_path
  end

  def manager
    verify_current_data
  end

  def search_spreadsheet
    $spreadsheet_group = Report.where(year: params[:year]).order('month_numb')
    redirect_to manager_path
  end

  def search_contract
    request = params[:month_year].split '/'
    $contract_group = Contract.where(report_id: Report.where(month: request[0], year: request[1])[0].id)
    redirect_to manager_path
  end

  def delete_spreadsheet
    request = params[:delete].split '/'
    Report.where(month: request[0], year: request[1].to_i)[0].destroy

    restart_spreadsheet_view
    redirect_to manager_path
  end

  def delete_contract
    request = params[:delete].split '/'
    Contract.where(day: request[0].to_i, report_id: request[1].to_i)[0].destroy

    restart_contract_view
    redirect_to manager_path
  end

  private

  def verify_current_data
    restart_spreadsheet_view if $spreadsheet_group.empty?
    restart_contract_view if $contract_group.empty?
  end

  def restart_spreadsheet_view
    $spreadsheet_group = Report.where(year: Report.distinct.order('year').pluck(:year)[-1]).order('month_numb')
  end

  def restart_contract_view
    current_year = Report.distinct.order('year').pluck(:year)[-1]
    current_month = Report.distinct.order('month_numb').pluck(:month_numb)[-1]
    $contract_group = Contract.where(report_id: Report.where(year: current_year, month_numb: current_month)[0].id)
  end
end
