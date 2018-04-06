module HomeSearchs
  def fetch_last_report
    last_year = fetch_last_year
    last_month = fetch_last_month(last_year)
    Report.where(month_numb: last_month, year: last_year)[0]
  end

  def fetch_last_year
    Report.distinct.order('year').pluck(:year)[-1]
  end

  def fetch_last_month(last_year)
    Report.distinct.where(year: last_year).order('month_numb').pluck(:month_numb)[-1]
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

  def fetch_all_years
    Report.distinct.order('year').pluck(:year).reverse
  end

  def fetch_report_by_years(year)
    Report.where(year: year).order('month_numb').reverse
  end

  def fetch_username_by_priority
    User.where('priority BETWEEN ? AND ?', 1, 2).order('full_name')
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

  def destroy_contract_by_contract_id(contract_id)
    contract = Contract.find_by(id: contract_id)
    report_id = contract.report_id
    contract.destroy
    report_id
  end
end
