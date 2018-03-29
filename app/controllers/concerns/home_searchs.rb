module HomeSearchs
  def fetch_last_report
    Report.where(month: fetch_last_month, year: fetch_last_year)[0]
  end

  def fetch_last_year
    Report.distinct.order('year').pluck(:year)[-1]
  end

  def fetch_last_month
    Report.distinct.order('month').pluck(:month)[-1]
  end

  def fetch_report(month_year)
    Report.where(month: month_year[0], year: month_year[1].to_i)[0]
  end

  def fetch_contract_by_report_id(report_id)
    Contract.where(report_id: report_id).order('day')
  end

  def fetch_user_by_id(user_id)
    User.find_by(id: user_id)
  end

  def fetch_username_by_id(user_id)
    User.find_by(id: user_id).full_name
  end
end
