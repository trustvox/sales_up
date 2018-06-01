class PageController < DashboardController
  before_action :init_view_data,
                only: %i[graphic spreadsheet manager overview]
  before_action :init_manager_data, only: [:manager]
  before_action :fetch_user_prioritys, only: [:manage_new_user]

  def graphic
    search
    @day_text = day_text_generator
    render_menu
  end

  def spreadsheet
    verify_authorize('s')
    search

    @contract = Contract.new
    @users = fetch_username_by_priority
    render_menu
  end

  def manager
    @user = User.new
    @new_users = fetch_user_by_priority(-1)
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

  def manage_new_user
    if @priority.nil?
      @user.destroy
    else
      @priority = 2 if @priority > 2
      @user.priority = @priority
      @user.save

      send_out_message(@user.email)
    end
    redirect_to controller: 'page', action: 'manager',
                'report[year]' => fetch_last_year
  end

  private

  def send_out_message(email)
    zapper = ZapierRuby::Zapper.new(:email_zap)
    zapper.zap(json_maker(email, 'Account permission allowed',
                          'Your account have been aproved: ' +
                          ENV['link_to_root']))
  end

  def fetch_user_prioritys
    @user = User.find_by(id: params[:user][:id])
    @priority = params[:user][:priority].to_i
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
    if which == 'm'
      authorize! :manager, PageController
    elsif which == 's'
      authorize! :spreadsheet, PageController
    end
  rescue CanCan::AccessDenied
    redirect_to graphic_path
  end

  def render_menu
    render layout: 'menu'
  end
end
