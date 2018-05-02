class PageController < DashboardController
  before_action :verify_spreadsheets, only: [:manager]
  before_action :start_overview_search, only: [:search_overview_data]
  before_action :init_main_data,
                only: %i[graphic spreadsheet manager overview]

  def graphic
    @report_data = session[:report_data]
    @report_points = session[:report_points]
    @contract_points = session[:contract_points]
    render_menu
  end

  def spreadsheet
    verify_authorize('s')
    @contract = Contract.new
    @report_data = session[:report_data]
    @users = session[:all_users]
    render_menu
  end

  def manager
    verify_authorize('m')
    @spreadsheets = session[:spreadsheets]
    @unique_years = fetch_report_by_unique_years(@spreadsheets[0].year)
    render_menu
  end

  def overview
    @reports = [session[:first_report], session[:last_report]]
    @goal_points = session[:goal_points]
    @sum_points = session[:sum_points]
    @first_list = session[:first_list]
    @last_list = session[:last_list]

    render_menu
  end

  def logout
    sign_out_and_redirect(current_user)
  end

  def search_overview_data
    overview_data
    selection_list

    adjust_list(session[:last_list], session[:last_report])
    redirect_to overview_path
  end

  private

  def start_overview_search
    return init_overview_data(nil, nil) if params[:report].nil?
    init_overview_data(params[:report][:month].split('/'),
                       params[:report][:year].split('/'))
  end

  def selection_list
    create_lists(session[:first_list])
    create_lists(session[:last_list])
    adjust_list(session[:first_list], session[:first_report])
  end

  def create_lists(date_list)
    all_date_list.map { |m| date_list << (m.month + '/' + m.year.to_s) }
  end

  def adjust_list(date_list, report)
    date_list.delete(report.month + '/' + report.year.to_s)
    date_list.unshift(report.month + '/' + report.year.to_s)
  end

  def init_main_data
    @report = Report.new
    @current_report = session[:current_report]
    @month_year_list = session[:month_year_list]
  end

  def verify_authorize(which)
    if which == 'm'
      authorize! :manager, PageController
    elsif which == 's'
      authorize! :spreadsheet, PageController
    end
  rescue CanCan::AccessDenied
    redirect_to graphic_path
  end

  def verify_spreadsheets
    session[:spreadsheets] = fetch_reports_by_current_year if nil?
  end

  def nil?
    session[:spreadsheets].blank?
  end

  def render_menu
    render layout: 'menu'
  end
end
