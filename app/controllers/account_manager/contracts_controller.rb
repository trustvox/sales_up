module AccountManager
  class ContractsController < ApplicationController
    before_action only: %i[create update] do
      valid_params(action_name)
    end

    def create
      set_contracts_params unless params[:contract][:user].to_i.zero?

      @contracts.save!

      redirect_to_monthly_sales
    end

    def update
      @contracts = Contract.find_by(id: params[:id])
      @contracts.update(contract_params)

      redirect_to_monthly_sales
    end

    def destroy
      @contracts = Contract.find_by(id: params[:id])
      @contracts.destroy

      redirect_to_monthly_sales
    end

    private

    def redirect_to_monthly_sales(action = nil)
      report = fetch_report_by_id(@contracts.report_id)
      message = @contracts.errors.messages.map { |msg| msg[1] }

      redirect_to controller: 'dashboard', action: 'monthly_sales',
                  'report[month]' => report.month, 'report[year]' => report.year,
                  notice: message + [[action]]
    end

    def valid_params(action)
      @contracts = Contract.new(contract_params)

      redirect_to_monthly_sales(action) unless @contracts.valid?
    end

    def set_contracts_params
      @contracts.value *= (params[:contract][:value_1].to_f / 100)
      @contracts.save!

      @contracts = Contract.new(contract_params)
      @contracts.value *= (params[:contract][:value_2].to_f / 100)
      @contracts.user_id = params[:contract][:user].to_i
    end

    def contract_params
      params.require(:contract).permit(:day, :store_name, :value,
                                       :report_id, :user_id)
    end
  end
end
