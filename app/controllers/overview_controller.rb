class OverviewController < MonthlyController
  include OverviewPoints

  before_action :init_overview_search_data, only: [:search_overview_data]

  def search_overview_data
    start_overview_search
    overview_data
    selection_list

    adjust_list(@last_list, @last_report)
  end

  private

  def init_overview_search_data
    @goal_points = '[ '
    @sum_points = '[ '
    @months_between = []

    @first_list = []
    @last_list = []

    @first_report = nil
    @last_report = nil
  end

  def start_overview_search
    return init_overview_data(nil, nil) if params[:report].nil?
    init_overview_data(params[:report][:month].split('/'),
                       params[:report][:year].split('/'))
  end

  def selection_list
    create_lists(@first_list)
    create_lists(@last_list)
    adjust_list(@first_list, @first_report)
  end

  def create_lists(date_list)
    all_date_list.map { |m| date_list << (m.month + '/' + m.year.to_s) }
  end

  def adjust_list(date_list, report)
    date_list.delete(report.month + '/' + report.year.to_s)
    date_list.unshift(report.month + '/' + report.year.to_s)
  end
end
