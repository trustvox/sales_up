module DatabaseSearchs
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

  def fetch_reports_by_month_range(current_report, quantity = 1)
    previous = current_report.month_numb - quantity
    if previous.negative?
      Report.where(month_numb: previous + 13, year: current_report.year - 1)[0]
    else
      Report.where(month_numb: previous, year: current_report.year)[0]
    end
  rescue StandardError
    nil
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

  #--------------------------------------------------------------------------##
  #--------------------------------------------------------------------------##
  #--------------------------------------------------------------------------##

  def fetch_contract_by_report_id(report_id)
    Contract.where(report_id: report_id).order('day')
  end

  def destroy_contract_by_id(contract_id)
    Contract.find_by(id: contract_id).destroy
  end

  def fetch_contracts_by_day_report_id(day, report_id)
    Contract.where(day: day, report_id: report_id)
  end

  def fetch_contracts_by_user_report_id(user_id, report_id)
    Contract.where(user_id: user_id, report_id: report_id).order('day')
  end

  #--------------------------------------------------------------------------##
  #--------------------------------------------------------------------------##
  #--------------------------------------------------------------------------##

  def fetch_username_by_id(user_id)
    User.find_by(id: user_id).full_name
  end

  def fetch_id_by_username(full_name)
    User.find_by(full_name: full_name).id
  end

  def fetch_username_by_priority
    User.where('priority BETWEEN ? AND ?', 1, 2).order('full_name')
  end

  def fetch_user_by_priority(priority)
    User.where(priority: priority)
  end

  #--------------------------------------------------------------------------##
  #--------------------------------------------------------------------------##
  #--------------------------------------------------------------------------##

  def month_days
    Time.days_in_month(@current_report.month_numb)
  end

  def all_date_list
    list = []
    fetch_all_years.each do |year|
      fetch_reports_by_year(year).each do |report|
        list << report
      end
    end
    list
  end
end
