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
  end

  def fetch_contract_by_day_report(day, month, year)
    Contract.where(day: day,
                   report_id: fetch_report_by_month_year(month, year))[0]
  end

  def destroy_contract_by_day_report(day, month, year)
    Contract.where(day: day,
                   report_id: fetch_report_by_month_year(month, year))[0]
            .destroy
  end

  def destroy_report_by_month_year(month, year)
    Report.where(year: year, month: month)[0].destroy
  end
end
