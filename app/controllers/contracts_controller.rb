class ContractsController < ApplicationController
  def create
    contract = Contract.new(contract_params)
    contract.user_id = fetch_id_by_username(params[:username])
    contract.save!
    redirect_to_monthly_sales(contract.report_id)
  end

  def update
    contract = Contract.find_by(id: params[:id])
    contract.update(contract_params)
    redirect_to_monthly_sales(contract.report_id)
  end

  def destroy
    contract = Contract.find_by(id: params[:id])
    contract.destroy
    redirect_to_monthly_sales(contract.report_id)
  end

  private

  def redirect_to_monthly_sales(id)
    report = fetch_report_by_id(id)
    redirect_to controller: 'dashboard', action: 'monthly_sales',
                'report[month]' => report.month, 'report[year]' => report.year
  end

  def contract_params
    params.require(:contract).permit(:day, :store_name, :value,
                                     :report_id, :user_id)
  end
end
