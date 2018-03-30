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

  def fetch_contract_by_report_id(report_id)
    Contract.where(report_id: report_id).order('day')
  end

  def fetch_contract_by_day_report(day, month, year)
    Contract.where(day: day,
                   report_id: fetch_report_by_month_year(month, year))[0]
  end

  def destroy_contract_by_contract_id(contract_id)
    contract = Contract.find_by(id: contract_id)
    report_id = contract.report_id
    contract.destroy
    report_id
  end

  def destroy_report_by_report_id(report_id)
    report = Report.find_by(id: report_id)
    year = report.year
    report.destroy
    year
  end

  def fetch_user_by_full_name(full_name)
    User.where(full_name: full_name)[0].id
  end
end
