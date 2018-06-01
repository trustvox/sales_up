class UserController < ApplicationController
  layout 'main'
  before_action :verify_user_status

  def user_home
    report = fetch_last_report
    @current_month = report.month
    @current_year = report.year
  end

  def forgot_password; end

  private

  def verify_user_status
    redirect_to monthly_sales_path if user_signed_in?
    @user = User.new
  end
end
