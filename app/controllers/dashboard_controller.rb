class DashboardController < MonthlyController
  before_action :init_view_data,
                only: %i[monthly_sales manager overview_reports
                         overview_months report_sales]
  before_action :init_manager_data, only: [:manager]

  before_action :authenticate_user!, only: [:manager]
  skip_before_action :verify_authenticity_token

  include GraphicHelper

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

    @graphic_text = day_text_generator

    render_menu
  end

  def manager
    render_menu
  end

  def overview_months
    search_overview_months
    init_overview_options_list

    @month_text = month_text_generator
    render_menu
  end

  def overview_reports
    search_overview_reports

    init_overview_options_list
    verify_options unless params[:report].nil?

    @month_text = month_text_generator
    render_menu
  end

  def logout
    sign_out_and_redirect(current_user)
  end

  private

  def init_overview_options_list
    @user_options = [['All Salesman', 'All']] +
                    fetch_username_by_salesman_priority.collect do |username|
                      [username, username]
                    end
    @filter_options = [['Contract Sum', 'CS'], ['Contracts Closed', 'CC'],
                       ["Goal's Percentage", 'CP']]
  end

  def verify_filter
    @filter_options.each do |op|
      next unless op[1] == params[:report][:goal]
      @filter_options.delete(op)
      @filter_options.unshift(op)
    end
  end

  def verify_user
    @user_options.each do |op|
      next unless op[1] == params[:report][:report_name]
      @user_options.delete(op)
      @user_options.unshift(op)
    end
  end

  def verify_options
    verify_filter

    return if params[:report][:report_name] == 'All'
    verify_user
  end

  def init_month_year
    @month_year = params[:report].nil? ? fetch_default_data : fetch_custom_data
    list = @month_year.split('/')

    @month = list[0]
    @year = list[1]
  end

  def fetch_custom_data
    params[:report][:month] + '/' + params[:report][:year].to_s
  end

  def init_manager_data
    authorize! :manager, DashboardController
    year = params[:report].nil? ? params[:year] : params[:report][:year]

    @spreadsheets = fetch_reports_by_year(year)
    @unique_years = fetch_report_by_unique_years(year.to_i)
  rescue CanCan::AccessDenied
    redirect_to graphic_path
  end

  def init_view_data
    @report = Report.new
  end

  def render_menu
    render layout: 'menu'
  end
end
