class UserController < ApplicationController
  layout 'main'
  before_action :graphic_path

  def user_home
    redirect_to @graphic_path if user_signed_in?
    @current_month = @report.month
    @current_year = @report.year
  end

  def forgot_password; end

  private

  def graphic_path
    @report = fetch_last_report
    @graphic_path = '/graphic/' + @report.month + '/' + @report.year.to_s
  end
end
