class PageController < DashboardController
  before_action :verify_spreadsheets, only: [:manager]
  before_action :init_main_data,
                only: %i[graphic spreadsheet manager overview]

  def graphic
    @report_data = session[:report_data]
    @report_points = session[:report_points]
    @contract_points = session[:contract_points]
    @day_text = day_text_generator
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
    @goal_points = session[:goal_points]
    @sum_points = session[:sum_points]
    @first_list = session[:first_list]
    @last_list = session[:last_list]
    @month_text = month_text_generator

    render_menu
  end

  def logout
    sign_out_and_redirect(current_user)
  end

  private

  def day_text_generator
    @day_text = "[ [1, 'Day/1'], "
    @report_data.each do |data|
      next if data[0] == '1'
      @day_text += '[' + data[0] + ", '#{data[0]}'], "
    end
    @day_text = @day_text[0..@day_text.length - 3] + ' ]'
  end

  def month_text_generator
    @month_text = []
    report = session[:first_report]
    i = 1
    while proceed?(report)
      add_month_text(i, report)
      report = fetch_report_by_next_month(report)
      i += 1
    end
    add_month_text(i, report)
  end

  def add_month_text(index, report)
    @month_text << [index, report.month[0..2] + '/' + report.year.to_s[2..3]]
  end

  def proceed?(report)
    !report.nil? && report.id != session[:last_report].id
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
    session[:spreadsheets] = fetch_reports_by_current_year if nil_spreadsheets?
  end

  def nil_spreadsheets?
    session[:spreadsheets].blank?
  end

  def render_menu
    render layout: 'menu'
  end
end
