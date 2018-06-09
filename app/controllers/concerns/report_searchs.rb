module ReportSearchs
  def fetch_last_report
    Report.where(month_numb: fetch_last_month, year: fetch_last_year)[0]
  end

  def fetch_last_year
    Report.distinct.order('year').pluck(:year)[-1]
  end

  def fetch_last_month
    Report.distinct.where(year: Time.current.year)
          .order('month_numb').pluck(:month_numb)[-1]
  end

  def fetch_report(month, year)
    Report.where(month: month, year: year.to_i)[0]
  rescue StandardError
    nil
  end

  def prepare_fetch_reports_by_month_range(report)
    @i = 1
    @first_month = report.month_numb
    @first_year = report.year
  end

  def fetch_reports_by_month_range(current_report, quantity = 1)
    prepare_fetch_reports_by_month_range(current_report)

    while @i < quantity
      @first_month -= 1
      if @first_month.zero?
        @first_month = 12
        @first_year -= 1
      end
      @i += 1
    end

    Report.where(month_numb: @first_month, year: @first_year)[0]
  end

  def fetch_report_by_next_month(current_report)
    if current_report.month_numb + 1 > 12
      fetch_report('January', (current_report.year + 1))
    else
      Report.where(month_numb: current_report.month_numb + 1,
                   year: current_report.year)[0]
    end
  rescue StandardError
    nil
  end

  def fetch_all_years
    Report.distinct.order('year').pluck(:year).reverse
  end

  def fetch_reports_by_year(year)
    Report.where(year: year).order('month_numb').reverse
  end

  def fetch_reports_by_current_year
    Report.where(year: fetch_last_year).order('month_numb').reverse
  end

  def fetch_report_by_unique_years(same_year = nil)
    list = Report.distinct.pluck(:year).reverse
    list.delete(same_year)
    list.unshift(same_year)
  end

  def fetch_report_by_id(id)
    Report.find_by(id: id)
  end
end
