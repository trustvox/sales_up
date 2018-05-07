class ReportsController < DashboardController
  before_action :prepare_params, only: %i[create update]

  def create
    report = Report.new(report_params)
    report.save!
    restore_report_data
  end

  def update
    report = Report.find_by(id: params[:id])
    report.update(report_params)
    restore_report_data
  end

  def search_report
    restore_report_data(false)
  end

  def destroy
    Report.find_by(id: params[:id]).destroy
    restore_report_data
  end

  private

  def prepare_params
    params[:report][:month] =
      Date::MONTHNAMES[params[:report][:month_numb].to_i]
  end

  def restore_report_data(can_search_month_year = true)
    session[:month_year_list] = all_date_list if can_search_month_year
    session[:spreadsheets] = fetch_reports_by_year(params[:report][:year])
    redirect_to manager_path
  end

  def report_params
    params.require(:report).permit(:report_name, :goal,
                                   :month, :month_numb, :year)
  end
end
