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

  def fetch_report(month_year)
    begin
      Report.where(month: month_year[0], year: month_year[1].to_i)[0]
    rescue StandardError
      nil
    end
  end

  def fetch_reports_by_month_range(current_report, quantity = 1)
    begin
      previous = current_report.month_numb - quantity
      if previous.negative?
        Report.where(month_numb: previous + 13, year: current_report.year - 1)[0]
      else
        Report.where(month_numb: previous, year: current_report.year)[0]
      end
    rescue StandardError
      nil
    end
  end

  def fetch_report_by_next_month(current_report)
    begin
      Report.where(month_numb: current_report.month_numb + 1, year: current_report.year)[0]
    rescue StandardError
      nil
    end
  end

  def fetch_all_years
    Report.distinct.order('year').pluck(:year).reverse
  end

  def fetch_reports_by_year(year)
    Report.where(year: year).order('month_numb').reverse
  end

  def destroy_report_by_report_id(report_id)
    report = Report.find_by(id: report_id)
    year = report.year
    report.destroy
    year
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

  #--------------------------------------------------------------------------##
  #--------------------------------------------------------------------------##
  #--------------------------------------------------------------------------##

  def fetch_username_by_id(user_id)
    User.find_by(id: user_id).full_name
  end

  def fetch_username_by_priority
    User.where('priority BETWEEN ? AND ?', 1, 2).order('full_name')
  end

  #--------------------------------------------------------------------------##
  #--------------------------------------------------------------------------##
  #--------------------------------------------------------------------------##

  def month_days
    Time.days_in_month(session[:current_report].month_numb)
  end
end
