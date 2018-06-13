module RecordDataPoints
  def initialize
    @record_data = []
  end

  def start_record_data
    @last_day = month_days
  end

  def fetch_record_data
    fetch_user_by_priority(1).collect do |user|
      prepare_data(user.id)

      next if @closed_contracts.empty?
      create_data_array(user.full_name)
    end
  end

  def create_data_array(username)
    [username, @closed_contracts.count, @sum,
     (@closed_contracts.count.to_f / @unique_days.count.to_f).round(1),
     ((@sum / @current_report.goal) * 100).round(1), @day_gap]
  end

  def prepare_data(user_id)
    @closed_contracts = fetch_closed_contracts(user_id, @current_report.id)

    return if @closed_contracts.empty?
    @sum = fetch_contract_sum(user_id, @current_report.id)
    @unique_days = fetch_unique_days(user_id, @current_report.id)
    @day_gap = calculate_delta_gap.sort[-1]
  end

  def start_record_points
    @last_day = month_days
  end

  def fetch_record_points
    fetch_user_by_priority(1).collect do |user|
      @list = []
      @sum = 0

      prepare_points(user.id)
      organize_data(user.id) unless @unique_days.empty?

      @list unless @unique_days.empty?
    end
  end

  def prepare_points(user_id)
    @unique_days = fetch_unique_days(user_id, @current_report.id)

    return if @unique_days.empty?
    @last_day = month_days
    @gap = calculate_delta_gap
  end

  def verify_first_unique_day
    @list << [1, 0]
    @list << [1 + @gap[0], 0]
    @gap.shift
  end

  def organize_data(user_id)
    verify_first_unique_day if @unique_days[0] != 1

    @unique_days.each_with_index do |day, i|
      add_day_sum(day, user_id, true)
      add_day_sum(day + @gap[i], user_id) if verify_add_day_sum(i)
    end

    add_day_sum(@last_day, user_id) if verify_last_day
  end

  def verify_add_day_sum(index)
    index < @gap.length && @gap[index] != 0
  end

  def verify_last_day
    @unique_days[-1] != @last_day
  end

  def contract_sum_in_day(day, report_id, user_id)
    fetch_contracts_by_day_report_user_id(day, report_id, user_id).map do |cont|
      @sum += cont.value.to_f
    end
  end

  def calculate_delta_gap
    gap_list = []

    @unique_days.each_with_index { |day, i| add_gap(gap_list, day, i) }
    finish_search(gap_list)
  end

  def add_day_sum(day, user_id, can_sum = false)
    contract_sum_in_day(day, @current_report.id, user_id) if can_sum
    @list << [day, @sum]
  end

  def add_gap(list, day, index, length = @unique_days.length)
    return if length <= 1
    list << (day - @unique_days[index + 1]).abs - 1 if index + 1 < length
  end

  def finish_search(gap_list)
    gap_list << (@last_day - @unique_days[-1]) if @unique_days[-1] != @last_day
    gap_list.unshift(@unique_days[0] - 2) if @unique_days[0] != 1

    gap_list
  end
end
