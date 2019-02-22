module AccountManager
  class ContractsController < ApplicationController
    before_action only: %i[create update] do
      valid_params(action_name)
    end

    def create
      contract_params = params[:contract]

      unless contract_params[:user].to_i.zero?
        @contracts.value *= (contract_params[:value_1].to_f / 100)
        @contracts.save!

        set_contracts_params
      end

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
      redirect_to_monthly_method(@contracts.report_id, @contracts.errors, 
                                 'sales', action)
    end

    def valid_params(action)
      @contracts = Contract.new(contract_params)

      redirect_to_monthly_sales(action) unless @contracts.valid?
    end

    def set_contracts_params
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
