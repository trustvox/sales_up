class MonthlyController < OverviewController
  include ContractDataPoints
  include ReportDataPoints
  include RecordDataPoints

  layout 'menu'
  before_action :authenticate_user!

  def init_month_year_list
    init_current_report

    @month_year_list = all_date_list
    @month_year_list.delete(@current_report)
    @month_year_list.unshift(@current_report)
  end

  def search_sales
    init_search_sales_data
    fetch_data_and_points
  end

  def search_recods
    init_search_record_data
    fetch_record_data_and_points
  end

  private

  def init_search_record_data
    @record_data = []
    @record_points = []

    @line_names = []
    @users = []
  end

  def fetch_record_data_and_points
    start_record_data
    @record_data = fetch_record_data

    start_record_points
    @record_points = fetch_record_points

    finish_record_search
  end

  def finish_record_search
    @record_data.delete(nil)
    @record_points.delete(nil)

    @line_names = @record_data.collect { |data| data[0] }
  end

  def init_search_sales_data
    @report_data = []
    @report_points = []

    @contract_data = []
    @contract_points = '[ ]'
  end

  def init_current_report
    return @current_report = fetch_last_report if params[:report].nil?
    @current_report =
      fetch_report(params[:report][:month], params[:report][:year])
  end

  def fetch_data_and_points
    result = fetch_contract_by_report_id(@current_report.id)

    @days = month_days
    @days -= 9 if @current_report.month_numb == 12

    fetch_contract_data_points(result) unless result.empty?
    fetch_report_data_points
  end

  def fetch_contract_data_points(data)
    start_contract(data)
    @contract_data = fetch_contract_data
    @contract_points = fetch_contract_points
  end

  def fetch_report_data_points
    start_data
    @report_data = fetch_report_data
    fetch_report_points
  end

  def fetch_report_points
    last_data = nil

    @report_data.map do |data|
      !@wait_to_sunday ? add_sunday_to_friday(data) : add_friday_to_sunday(data)
      last_data = data
    end

    add_data(last_data) if @report_points[-1][0] != last_data[0]
  end

  def add_first_data(data)
    @report_points << [data[0].to_i, data[2].to_f]
    @wait_to_sunday = true if data[1] == 'Friday' || data[1] == 'Saturday'
  end

  def add_data(data, wait = false)
    @report_points << [data[0].to_i, data[2].to_f]
    @wait_to_sunday = wait
  end

  def add_sunday_to_friday(data)
    add_first_data(data) if data[0] == '1'
    add_data(data, true) if data[1] == 'Friday' && data[0] != '1'
  end

  def add_friday_to_sunday(data)
    add_data(data) if data[1] == 'Sunday'
  end
end
