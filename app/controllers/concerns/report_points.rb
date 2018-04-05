module ReportPoints
  def start_points(day, data, points)
    @report_data = data
    @report_points = points
    @last_day = day
  end

  def fetch_report_points
    @list = []
    last_data = nil
    @report_data.map do |data|
      !@wait_to_sunday ? add_sunday_to_friday(data) : add_friday_to_sunday(data)
      last_data = data
    end
    add_data(last_data, false) if @list[-1][0] != last_data[0]
    @report_points += ']'
  end

  private

  # ---------------------------------------------------------------------------
  # ---------------------------------------------------------------------------
  # -----------------------fetch_report_points_auxilires-----------------------
  # ---------------------------------------------------------------------------
  # ---------------------------------------------------------------------------

  def add_first_data(data)
    @list << [data[0], data[2]]
    @report_points += '[' + data[0] + ',' + data[2] + ']'
    @wait_to_sunday = true if data[1] == 'Friday' || data[1] == 'Saturday'
  end

  def add_data(data, wait)
    @list << [data[0], data[2]]
    @report_points += ', [' + data[0] + ',' + data[2] + ']'
    @wait_to_sunday = wait
  end

  def add_sunday_to_friday(data)
    add_first_data(data) if data[0] == '1'
    add_data(data, true) if data[1] == 'Friday' && data[0] != '1'
  end

  def add_friday_to_sunday(data)
    add_data(data, false) if data[1] == 'Sunday'
  end
end
