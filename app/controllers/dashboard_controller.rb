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
    @user = User.new
    @new_users = fetch_user_by_priority(-1)

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

  def manage_new_user
    if @priority.nil?
      @user.destroy
    else
      @priority = 2 if @priority > 2
      @user.priority = @priority
      @user.save

      send_out_message(@user.email)
    end
    redirect_to controller: 'dashboard', action: 'manager',
                'report[year]' => fetch_last_year
  end

  private

  def send_out_message(email)
    zapper = ZapierRuby::Zapper.new(:email_zap)
    zapper.zap(json_maker(email, 'Account permission allowed',
                          'Your account have been aproved: ' +
                          ENV['link_to_root']))
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
