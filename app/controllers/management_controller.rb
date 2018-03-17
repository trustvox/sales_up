class ManagementController < ApplicationController
	before_action :authenticate_user!
	skip_before_action :verify_authenticity_token
	
	$spreadsheet_group = []
	$contract_group = []

  def view
  	$spreadsheet_group = Report.where(:year => Report.distinct.order('year').pluck(:year)).order('month_numb')
  	$contract_group = Contract.where(:report_id => Report.where(:year => Report.distinct.order('year').pluck(:year)))
  	redirect_to manager_path
  end

  def manager
  	
  end

  def search_spreadsheet
  	$spreadsheet_group = Report.where(:year => params[:year]).order('month_numb')
    redirect_to manager_path
  end

  def search_contract
    request = params[:month_year].split "/"
  	$contract_group = Contract.where(:report_id => Report.where(:month => request[0], :year => request[1])[0].id)
    redirect_to manager_path
  end

  def delete_spreadsheet
  	
  end

  def delete_contract
  	
  end
end