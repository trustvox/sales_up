module OverviewPoints
  include DatabaseSearchs
  include OverviewHelper

  def initialize
    @goal_points = []
    @sum_points = []
    @AM_points = []

    @first_report = nil
    @last_report = nil
  end

  def init_overview_data(type, first = nil, last = nil)
    if first.blank? || last.blank?
      @last_report = fetch_last_report(type)
      reports_count = fetch_report_count_by_type(type)
      range = reports_count < 12 ? reports_count : 12

      @first_report = fetch_reports_by_month_range(@last_report, type, range)
    else
      @last_report = fetch_report(last[0], last[1], type)
      @first_report = fetch_report(first[0], first[1], type)
      verify_dates
    end
  end

  def acceptable?
    !@first.nil? && (@first.month_numb != @last_report.month_numb ||
      @first.year != @last_report.year)
  end

  def prepare_overview_data(type = nil)
    @i = 1
    @first = @first_report
    @type = type unless type.nil?
  end

  def overview_data(which, type)
    prepare_overview_data(type)
    which == 'm' ? overview_month_data : overview_report_data
  end

  def overview_month_data
    while acceptable?
      add_goal_sum
      verify_next_month
    end

    add_goal_sum
  end

  def add_goal_sum
    @goal_points << [@i, @first.goal.to_f]
    @sum_points << [@i, fetch_sum(@first.id)]
  end

  def verify_next_month
    @i += 1
    report = fetch_report_by_next_month(@first, @type)
    @first = report
  end

  def fetch_sum(id)
    sum = 0

    if @type == 'AM'
      fetch_contract_by_report_id(id).each do |cont| {sum += cont.value.to_f }
    else
      fetch_meeting_by_report_id(id).each { |_meeting| sum += 1 }
    end

    sum.to_s
  end

  def overview_report_data
    @users.collect do |user|
      list = []
      
      while acceptable?
        list << verify_filter_option(user.id)
        verify_next_month
      end

      list << verify_filter_option(user.id)
      prepare_overview_data

      list
    end
  end

  def verify_filter_option(user_id)
    @type == 'AM' ? AM_filter(user_id) : SDR_filter(user_id)
  end

  def AM_filter(user_id)
    case @filter
    when 'CS'
      [@i, fetch_contract_sum(user_id, @first.id)]
    when 'CP'
      sum = fetch_contract_sum(user_id, @first.id)
      [@i, ((sum / fetch_goal_by_id(@first.id)) * 100).round(1)]
    when 'CC'
      [@i, fetch_contracts_by_user_report_id(user_id, @first.id)]
    end
  end

  def SDR_filter(user_id)
    case @filter
    when 'MS'
      [@i, fetch_meeting_sum(user_id, @first.id)]
    when 'MP'
      sum = fetch_meeting_sum(user_id, @first.id)
      [@i, ((sum / fetch_goal_by_id(@first.id)) * 100).round(1)]
    end
  end
end
