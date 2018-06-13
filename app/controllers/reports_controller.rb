class ReportsController < ApplicationController
  before_action :prepare_month_param, only: %i[create update]

  def create
    report = Report.new(report_params)
    report.save!
    redirect_to_manager(report.year)
  end

  def update
    report = Report.find_by(id: params[:id])
    report.update(report_params)
    redirect_to_manager(report.year)
  end

  def destroy
    report = Report.find_by(id: params[:id])
    report.destroy
    redirect_to_manager(report.year)
  end

  private

  def redirect_to_manager(year)
    redirect_to controller: 'dashboard', action: 'manager',
                'report[year]' => year
  end

  def prepare_month_param
    params[:report][:month] =
      Date::MONTHNAMES[params[:report][:month_numb].to_i]
  end

  def report_params
    params.require(:report).permit(:report_name, :goal,
                                   :month, :month_numb, :year)
  end
end
