module OverviewPoints
  include DatabaseSearchs

  def initialize
    @goal_points = '[ '
    @sum_points = '[ '
    @months_between = []

    @first_list = []
    @last_list = []

    @first_report = nil
    @last_report = nil
  end

  def init_overview_data(first, last)
    first.blank? ? fetch_reports : fetch_reports(first, last)
    @months_between = [@first_report]
  end

  def fetch_reports(first = nil, last = nil)
    if all_nil?(first, last)
      @last_report = fetch_last_report
      @first_report =
        fetch_reports_by_month_range(@last_report, 6)
    else
      search_first_last_reports(first, last)
      verify_dates
    end
  end

  def search_first_last_reports(first, last)
    @last_report = fetch_report(last[0], last[1])
    @first_report = fetch_report(first[0], first[1])
  end

  def all_nil?(first, last)
    first.blank? || last.blank?
  end

  def greater_month
    @first_report.month_numb < @last_report.month_numb
  end

  def greater_year
    @first_report.year > @last_report.year
  end

  def same_year
    @first_report.year == @last_report.year
  end

  def switch
    @first_report, @last_report =
      @last_report, @first_report
  end

  def verify_dates
    switch if (same_year && !greater_month) || greater_year
  end

  def acceptable?(first)
    !first.nil? &&
      (first.month_numb != @last_report.month_numb + 1 ||
      first.year != @last_report.year)
  end

  def overview_data
    @i = 1
    first = @first_report

    while acceptable?(first)
      store_data(@i.to_s, first.goal.to_s, first.id)
      first = verify_next_month(first)
    end

    @goal_points[-1] = ']'
    @sum_points[-1] = ']'
  end

  def store_data(index, goal, id)
    @goal_points += '[' + index + ', ' + goal + '], '
    @sum_points += '[' + index + ', ' + fetch_sum(id) + '], '
  end

  def verify_next_month(first)
    @i += 1
    report = fetch_report_by_next_month(first)
    @months_between << report unless report.nil?
    report
  end

  def fetch_sum(id)
    sum = 0
    fetch_contract_by_report_id(id).each do |contract|
      sum += contract.value
    end
    sum.to_s
  end
end
