class DashboardController < OverviewController
  before_action :init_view_data,
                only: %i[monthly_sales manager overview_reports
                         overview_months report_sales]
  before_action :init_month_year_list, only: %i[monthly_sales report_sales]
  before_action :init_manager_data, only: [:manager]

  before_action :authenticate_user!, only: [:manager]
  skip_before_action :verify_authenticity_token

  def monthly_sales
    init_month_year_list
    search_sales

    @contract = Contract.new
    @day_text = day_text_generator
    @users = fetch_username_by_priority

    @month = ''
    @year = ''
    init_month_year

    render_menu
  end

  def report_sales
    init_month_year_list
    search_recods

    @day_text = day_text_generator

    render_menu
  end

  def manager
    render_menu
  end

  def overview_months
    search_overview_months
    @month_text = month_text_generator
    render_menu
  end

  def overview_reports
    search_overview_reports
    @month_text = month_text_generator
    render_menu
  end

  def logout
    sign_out_and_redirect(current_user)
  end

  private

  def init_month_year
    @month_year = if params[:report].nil?
                    fetch_default_data
                  else
                    fetch_custom_data
                  end
    list = @month_year.split('/')
    @month = list[0]
    @year = list[1]
  end

  def fetch_default_data
    Date::MONTHNAMES[fetch_last_month] + '/' + fetch_last_year.to_s
  end

  def fetch_custom_data
    params[:report][:month] + '/' + params[:report][:year].to_s
  end

  def init_manager_data
    verify_authorization
    year = params[:report].nil? ? params[:year] : params[:report][:year]

    @spreadsheets = fetch_reports_by_year(year)
    @unique_years = fetch_report_by_unique_years(year.to_i)
  end

  def day_text_generator
    (1..month_days).collect { |day| [day, day.to_s] }
  end

  def month_text_generator
    @month_text = []
    report = @first_report
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
    !report.nil? && report.id != @last_report.id
  end

  def init_view_data
    @report = Report.new
  end

  def verify_authorization
    authorize! :manager, DashboardController
  rescue CanCan::AccessDenied
    redirect_to graphic_path
  end

  def render_menu
    render layout: 'menu'
  end
end
