class PageController < DashboardController
  before_action :init_view_data,
                only: %i[monthly_sales manager overview report_sales]
  before_action :init_month_year_list, only: %i[monthly_sales report_sales]
  before_action :init_manager_data, only: [:manager]
  before_action :init_monthly_sales_data, only: [:monthly_sales]

  def monthly_sales
    init_month_year_list
    search

    @contract = Contract.new
    @day_text = day_text_generator
    @users = fetch_username_by_priority

    render_menu
  end

  def report_sales
    init_month_year_list
    render_menu
  end

  def manager
    render_menu
  end

  def overview
    search_overview_data
    @month_text = month_text_generator
    render_menu
  end

  def logout
    sign_out_and_redirect(current_user)
  end

  private

  def init_monthly_sales_data
    @month = ''
    @year = ''
    if params[:report].nil?
      @month = Date::MONTHNAMES[fetch_last_month]
      @year = fetch_last_year.to_s
    else
      @month = params[:report][:month]
      @year = params[:report][:year].to_s
    end
  end

  def init_manager_data
    verify_authorize('m')
    year = params[:report].nil? ? params[:year] : params[:report][:year]

    @spreadsheets = fetch_reports_by_year(year)
    @unique_years = fetch_report_by_unique_years(year.to_i)
  end

  def day_text_generator
    @report_data.collect { |data| [data[0], (data[0]).to_s] }
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

  def verify_authorize(which)
    authorize! :manager, PageController if which == 'm'
  rescue CanCan::AccessDenied
    redirect_to graphic_path
  end

  def render_menu
    render layout: 'menu'
  end
end
