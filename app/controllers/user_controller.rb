class UserController < ApplicationController
  before_action :verify_user_status
  layout 'main'

  def user_home
    report = fetch_last_report
    @current_month = report.month
    @current_year = report.year
  end

  def forgot_password; end

  def register
    @user = User.new
  end

  private

  def verify_user_status
    redirect_to graphic_path if user_signed_in?
  end
end
