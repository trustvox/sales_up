module ReportData
  def initialize
    @contract_data = []

    @first_date = nil
    @last_date = nil
    @weekdays = nil

    @goal = 0
    @value = 0
    @factor = 0
    @index = 0
  end

  def start_data(day, report = nil, contract = [])
    @contract_data = contract
    fetch_date_values(day, report)

    @factor = 2
    @goal = (report.goal / find_business_days).round 2
    @value = @goal
    @index = 0
  end

  def fetch_date_values(day, report)
    @first_date = Date.parse(report.year.to_s + '-' + report.month + '-1')
    @last_date = @first_date + day - 1
    @weekdays = find_weekdays
  end

  def fetch_report_data
    report_data = []
    (@first_date..@last_date).each do |date|
      report_data << verify_data(date)
    end
    report_data
  end

  # ---------------------------------------------------------------------------
  # ---------------------------------------------------------------------------
  # -----------------------fetch_report_points_auxilires-----------------------
  # ---------------------------------------------------------------------------
  # ---------------------------------------------------------------------------

  def verify_data(date)
    (verify_report_values(date) + verify_contract_values(date))
  end

  def verify_report_values(date)
    if date.mday != 1 && date.on_weekday?
      @value = @goal * @factor
      @factor += 1
    end
    [date.mday.to_s, @weekdays[date.mday - 1], @value.to_s]
  end

  def verify_contract_values(date)
    return [0, '-', 0, '-'] if @contract_data.nil?

    value = @contract_data[@index]
    if !value.nil? && value[0] == date.mday
      increase_index
      return [value[1], value[2], value[3], value[4]]
    end

    [day_value_by_index, '-', 0, '-']
  end

  def increase_index
    @index += 1 unless @index + 1 >= @contract_data.size
  end

  def day_value_by_index
    @index != 0 ? @contract_data[@index][1] : 0
  end

  def find_business_days
    business_days = 0
    (@first_date..@last_date).each do |date|
      business_days += 1 unless date.saturday? || date.sunday?
    end
    business_days
  end

  def find_weekdays
    list = []
    (@first_date..@last_date).each do |date|
      list << int_to_weekday(date) if date.wday < 6 && date.wday >= 1
      list << int_to_weekend(date) if date.wday == 6 || date.wday.zero?
    end
    list
  end

  def int_to_weekday(date)
    return 'Monday' if date.monday?
    return 'Tuesday' if date.tuesday?
    return 'Wednesday' if date.wednesday?
    return 'Thursday' if date.thursday?
    'Friday'
  end

  def int_to_weekend(date)
    return 'Saturday' if date.saturday?
    'Sunday'
  end
end