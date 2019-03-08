module AccountManager
  class DealsController < ApplicationController
    before_action only: %i[create update] do
      valid_params(action_name)
    end

    def create
      @deals.save!

      redirect_to_monthly_sales
    end

    def update
      @deals = Deal.find_by(id: params[:id])
      @deals.update(deal_params)

      redirect_to_monthly_sales
    end

    def destroy
      @deals = Deal.find_by(id: params[:id])
      @deals.destroy

      redirect_to_monthly_sales
    end

    private

    def redirect_to_monthly_sales(action = nil)
      redirect_to_monthly_method(@deals.report_id, @deals.errors,
                                 'forecast', action)
    end

    def valid_params(action)
      @deals = Deal.new(deal_params)

      redirect_to_monthly_sales(action) unless @deals.valid?
    end

    def deal_params
      params.require(:deal).permit(:day, :client_name, :value,
                                   :report_id, :user_id)
    end
  end
end
