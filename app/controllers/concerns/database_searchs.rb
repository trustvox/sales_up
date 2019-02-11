module DatabaseSearchs
  include ReportSearchs
  include ContractSearchs
  include UserSearchs
  include MeetingSearchs

  def month_days
    time = Time.days_in_month(@current_report.month_numb)
    @current_report.month_numb == 12 ? time - 9 : time
  end

  def fetch_last_day
    today = Time.current

    @current_report.month_numb != today.month ? month_days : today.day
  end

  def all_date_list(type)
    report = []

    list = fetch_all_years.collect { |year| search_reports_in_year(year, type) }
    list.each { |rep| report += rep }

    report
  end

  def find_business_days(first = 1, last = month_days)
    prepare_fetch_gap_without_weekend(first, last)

    business_days = 0
    (@first_date..@last_date).each do |date|
      business_days += 1 unless date.saturday? || date.sunday?
    end

    business_days
  end

  def prepare_business_days(month_numb, year)
    year = year.to_i
    month_numb = month_numb.to_i

    @first_date = Date.new(year, month_numb, 1)
    @last_date = Date.new(year, month_numb, Time.days_in_month(month_numb))
  end

  def find_business_days_without_report(month_numb, year)
    prepare_business_days(month_numb, year)

    business_days = 0
    (@first_date..@last_date).each do |date|
      business_days += 1 unless date.saturday? || date.sunday?
    end

    business_days
  end

  def search_reports_in_year(year, type)
    fetch_reports_by_year(year, type).collect { |report| report }
  end

  def prepare_fetch_gap_without_weekend(first, last)
    if first.is_a? Integer
      @first_date =
        Date.new(@current_report.year, @current_report.month_numb, first)
      @last_date =
        Date.new(@current_report.year, @current_report.month_numb, last)
    else
      @first_date = first
      @last_date = last
    end
  end

  def fetch_gap_without_weekend(first_last_days)
    gap = first_last_days[1] - first_last_days[0]
    prepare_fetch_gap_without_weekend(first_last_days[0], first_last_days[1])

    (@first_date..@last_date).each do |date|
      gap -= 1 if date.saturday? || date.sunday?
    end
    
    gap
  end

  def fetch_token_usage(token)
    TokenPassword.find_by(token: token).used == 'no'
  end
end
