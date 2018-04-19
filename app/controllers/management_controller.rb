class ManagementController < DashboardController
  def view
    session[:report_year] = fetch_last_year
    session[:spreadsheets] = fetch_reports_by_year(session[:report_year])

    redirect_to manager_path
  end

  def manager
    begin
      authorize! :manager, ManagementController
    rescue CanCan::AccessDenied
      redirect_to graphic_path
    end

    @year = session[:report_year]
    @current_report = session[:current_report]
    @month_year_list = session[:month_year_list]

    render_menu
  end

  def overview
    @month_year_list = session[:month_year_list]
    @reports = [session[:first_report], session[:last_report]]

    @current_report = session[:current_report]
    @goal_points = session[:goal_points]
    @sum_points = session[:sum_points]
    @months_between = session[:months_between]

    render_menu
  end

  def add_spreadsheet
    @report = Report.new
    fetch_and_reload_spreadsheet(params[:report_name], params[:goal],
                                 params[:month], params[:year])
  end

  def alter_spreadsheet
    request = params[:add_alter].split('/-/')
    id = request[0].split('id:')

    @report = Report.find_by(id: id[1].to_i)
    fetch_and_reload_spreadsheet(request[1], request[2],
                                 request[3], request[4])
  end

  def search_spreadsheet
    session[:spreadsheets] = fetch_reports_by_year(params[:year])

    session[:report_year] = params[:year].to_i
    redirect_to manager_path
  end

  def delete_spreadsheet
    year = destroy_report_by_report_id(params[:delete])

    session[:spreadsheets] = fetch_reports_by_year(year)
    redirect_to manager_path
  end

  private

  def fetch_and_reload_spreadsheet(name, goal, month, year)
    fetch_report_values(name, goal, month, year)
    @report.save!

    session[:spreadsheets] = fetch_reports_by_year(year)
    session[:month_year_list] = month_year_list
    redirect_to manager_path
  end

  def fetch_report_values(name, goal, month, year)
    @report.report_name = name
    @report.goal = goal

    @report.month_numb = Date.parse(year.to_s + month + '-01').month
    @report.month = month
    @report.year = year
  end
end
