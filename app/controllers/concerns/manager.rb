module Manager
  def fetch_last_year
    Report.distinct.order('year').pluck(:year)[-1]
  end

  def fetch_last_month
    Report.distinct.order('month').pluck(:month)[-1]
  end

  def fetch_report_by_month_year(month, year)
    Report.where(year: year, month: month)[0]
  end

  def fetch_report_by_year(year)
    Report.where(year: year).order('month_numb')
  end

  def fetch_contract_by_report(month, year)
    Contract.where(report_id: fetch_report_by_month_year(month, year).id)
            .order('day')
  end

  def fetch_contract_by_day_report(day, month, year)
    Contract.where(day: day,
                   report_id: fetch_report_by_month_year(month, year))[0]
  end

  def destroy_report_by_report_id(report_id)
    report = Report.find_by(id: report_id)
    year = report.year
    report.destroy
    year
  end

  def month_year_list
    list = []
    fetch_all_years.each do |year|
      fetch_report_by_years(year).each do |report|
        list << report
      end
    end
    list
  end
end
