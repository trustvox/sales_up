class ContractsController < DashboardController
  def create
    contract = Contract.new(contract_params)
    contract.save!
    restore_contract_data(true, contract.report_id)
  end

  def update
    contract = Contract.find_by(id: params[:id])
    contract.update(contract_params)
    restore_contract_data
  end

  def destroy
    Contract.find_by(id: params[:id]).destroy
    restore_contract_data
  end

  private

  def restore_contract_data(can_search = false, report_id = 0)
    session[:current_report] = fetch_report_by_id(report_id) if can_search
    fetch_data_and_points
    redirect_to spreadsheet_path
  end

  def contract_params
    params.require(:contract).permit(:day, :store_name, :value,
                                     :report_id, :user_id)
  end
end
