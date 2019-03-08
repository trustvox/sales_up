module DatabaseSearchs
  include ReportSearchs
  include ContractSearchs
  include UserSearchs
  include MeetingSearchs
  include DealSearchs

  def month_days
    time = Time.days_in_month(@current_report.month_number)
    @current_report.month_number == 12 ? time - 9 : time
  end

  def fetch_last_day
    today = Time.current

    @current_report.month_number != today.month ? month_days : today.day
  end

  def all_date_list(type)
    report = []

    list = fetch_all_years.collect { |year| search_reports_in_year(year, type) }
    list.each { |rep| report += rep }

    report
  end

  def find_business_days(last = month_days, first = 1)
    prepare_fetch_gap_without_weekend(first, last)

    business_days = 0
    (@first_date..@last_date).each do |date|
      business_days += 1 unless date.saturday? || date.sunday?
    end

    business_days
  end

  def prepare_business_days(month_number, year)
    year = year.to_i
    month_number = month_number.to_i

    @first_date = Date.new(year, month_number, 1)
    @last_date = Date.new(year, month_number, Time.days_in_month(month_number))
  end

  def find_business_days_without_report(month_number, year)
    prepare_business_days(month_number, year)

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
        Date.new(@current_report.year, @current_report.month_number, first)
      @last_date =
        Date.new(@current_report.year, @current_report.month_number, last)
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

  def verify_friday_to_monday(day, index)
    first = Date.new(@current_report.year, @current_report.month_number, day)
    last = first + (@unique_days[index + 1] - 1)

    return 0 if first.friday? && last.monday?

    (day - @unique_days[index + 1]).abs - 1
  end

  def verify_current_with_last_day(gap_index)
    last_day = month_finished?

    gap = last_day - @unique_days[-1]

    return [@unique_days[-1], last_day.day] if gap > @result

    [@unique_days[gap_index] + 1, @unique_days[gap_index + 1]]
  end

  def month_finished?(_day)
    today = Date.current
    last =
      Date.new(@current_report.year, @current_report.month_number + 1, 1) - 1

    if today.month_number == last.month_number && today.year == last.year
    end
  end
end
