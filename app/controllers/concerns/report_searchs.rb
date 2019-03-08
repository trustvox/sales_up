module ReportSearchs
  RANGE_MONTHS = 12

  def fetch_last_report(type)
    Report.where(month_number: fetch_last_month(type),
                 year: fetch_last_year_with_type(type), goal_type: type)[0]
  end

  def fetch_last_year
    Report.distinct.order('year').pluck(:year)[-1]
  end

  def fetch_last_year_with_type(type)
    Report.distinct.where(goal_type: type).order('year').pluck(:year)[-1]
  end

  def fetch_last_month(type)
    Report.distinct.where(year: fetch_last_year_with_type(type),
                          goal_type: type).order('month_number')
          .pluck(:month_number)[-1]
  end

  def fetch_report(month, year, type)
    Report.where(month: month, year: year.to_i, goal_type: type)[0]
  rescue StandardError
    nil
  end

  def fetch_report_with_month_number(number, year, type)
    Report.where(month_number: number.to_i, year: year.to_i, goal_type: type)[0]
  end

  def prepare_fetch_reports_by_month_range(report)
    @i = 1
    @first_m = report.month_number
    @first_y = report.year
  end

  def fetch_reports_by_month_range(current_report, type, month = RANGE_MONTHS)
    prepare_fetch_reports_by_month_range(current_report)

    while @i < month
      @first_m -= 1

      if @first_m.zero?
        @first_m = 12
        @first_y -= 1
      end

      @i += 1
    end

    Report.where(month_number: @first_m, year: @first_y, goal_type: type)[0]
  end

  def fetch_report_by_next_month(current_report, type)
    if current_report.month_number + 1 > 12
      fetch_report('January', (current_report.year + 1), type)
    else
      Report.where(month_number: current_report.month_number + 1,
                   year: current_report.year, goal_type: type)[0]
    end
  rescue StandardError
    nil
  end

  def fetch_all_years
    Report.distinct.order('year').pluck(:year).reverse
  end

  def fetch_reports_by_year(year, type)
    Report.where(year: year, goal_type: type).order('month_number').reverse
  end

  def fetch_reports_by_current_year
    Report.where(year: fetch_last_year).order('month_number').reverse
  end

  def fetch_report_by_unique_years(type, same_year = nil)
    list = Report.distinct.where(goal_type: type).pluck(:year).reverse
    list.delete(same_year)
    list.unshift(same_year)
  end

  def fetch_report_by_unique_types
    Report.distinct.order('goal_type').pluck(:goal_type)
  end

  def fetch_report_by_id(id)
    Report.find_by(id: id)
  end

  def fetch_goal_by_id(id)
    Report.find_by(id: id).goal.to_f
  end

  def fetch_report_count_by_type(type)
    Report.where(goal_type: type).count
  end

  def fetch_individual_goal_by_id(id)
    goals = fetch_report_by_id(id).individual_goal.split('-')

    goals.each_with_index do |goal, i|
      next if i.odd?

      goals[i] = fetch_username_by_id(goal.to_i)
      goals[i + 1] = goals[i + 1].to_f
    end

    goals
  end

  def fetch_user_by_individual_goal_with_id(id)
    goals = []
    list = fetch_report_by_id(id).individual_goal.split('-')

    list.each_with_index { |goal, i| goals << goal.to_i unless i.odd? }

    goals
  end
end
