module ReportDataPoints
  include GraphicHelper

  def initialize
    @first = nil
    @last = nil
    @weekdays = nil

    @goal = 0
    @value = 0
    @factor = 0
    @index = 0
    @overall_data = nil
  end

  def start_data
    fetch_date_values(@current_report)
    fetch_data_values

    @index = 0
  end

  def fetch_data_values
    @goal = (@current_report.goal / find_business_days).round(2)

    if @first.mday == 1 && @first.on_weekend?
      @factor = 1
      @value = 0
    else
      @factor = 2
      @value = @goal.to_i
    end
  end

  def fetch_date_values(report)
    @first = Date.parse(report.year.to_s + '-' + report.month + '-1')
    @last = @first + month_days - 1
    @weekdays = find_weekdays
  end

  def fetch_report_data(data)
    @overall_data = data
    (@first..@last).collect { |date| verify_data(date) }
  end

  def verify_data(date)
    verify_report_values(date) + verify_contract_values(date)
  end

  def verify_report_values(date)
    if date.mday != 1 && date.on_weekday?
      @value = fetch_value_raise
      @factor += 1
    end
    [date.mday.to_s, @weekdays[date.mday - 1], @value.to_s]
  end

  def fetch_value_raise
    return @goal * @factor if @current_report.scheduled_raise.zero?

    @factor * @current_report.scheduled_raise
  end

  def verify_data_values
    return [0, '-', 0, '-'] if @current_report.scheduled_raise.nil?

    [0, 0, '-', 0, '-', '-', '-']
  end

  def verify_contract_values(date)
    return verify_data_values if date.nil?

    value = @overall_data[@index]

    if !value.nil? && value[0] == date.mday
      increase_index
      list = []
      value.each_with_index { |data, i| i.zero? ? next : list << data }

      return list
    end

    [day_value_by_index, '-', 0, '-']
  end

  def increase_index
    @index += 1 if @index < @overall_data.size
  end

  def day_value_by_index
    return 0 if @index.zero?
    
    @overall_data[@index - 1][1]
  end

  def fetch_report_points
    last_data = nil
    
    @report_data.map do |data|
      !@wait_to_sunday ? add_sun_to_fri(data) : add_fri_to_sun(data)
      last_data = data
    end
    
    add_data(last_data) if @report_points[-1][0] != last_data[0]
  end

  def add_first_data(data)
    @report_points << [data[0].to_i, data[2].to_f]
    @wait_to_sunday = true if data[1] == 'Friday' || data[1] == 'Saturday'
  end

  def add_data(data, wait = false)
    @report_points << [data[0].to_i, data[2].to_f]
    @wait_to_sunday = wait
  end

  def add_sun_to_fri(data)
    add_first_data(data) if data[0] == '1'
    add_data(data, true) if data[1] == 'Friday' && data[0] != '1'
  end

  def add_fri_to_sun(data)
    add_data(data) if data[1] == 'Sunday'
  end
end
