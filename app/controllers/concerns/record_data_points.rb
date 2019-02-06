module RecordDataPoints
  def start_record_data(type)
    @last_day = month_days
    @which = type == 'AM'
  end

  def fetch_record_data(type)
    fetch_user_by_individual_goal(@current_report.id).collect do |user|
      next fetch_empty_data_array(user) if verify_fetched_data(user.id)

      @which ? prepare_AM_data(user.id) : prepare_SDR_data(user.id)
      @day_gap = fetch_gap

      create_data_array(user.full_name, user.id)
    end
  end

  def verify_fetched_data(user_id)
    return fetch_closed_contracts(user_id, @current_report.id).empty? if @which
    fetch_scheduled_meeting(user_id, @current_report.id).empty?
  end

  def fetch_empty_data_array(user)
    @which ? [user.full_name, 0, 0, 0, 0, 0] : [user.full_name, 0, 0, 0, 0]
  end

  def prepare_AM_data(user_id)
    @sum = fetch_contract_sum(user_id, @current_report.id)
    @unique_days = fetch_unique_days_contract(user_id, @current_report.id)
  end

  def prepare_SDR_data(user_id)
    @sum = fetch_meeting_sum(user_id, @current_report.id)
    @unique_days = fetch_unique_days_meeting(user_id, @current_report.id)
  end

  def fetch_gap
    @gap_index = 0
    @result = 0
    @gap_list = calculate_gap

    @gap_list = verify_first_last_days
    fetch_gap_without_weekend(@gap_list)
  end

  def verify_first_last_days
    if @unique_days[0] != 1 && @unique_days[0] - 1 > @result
      return [1, @unique_days[0]]
    end

    last_day = fetch_last_day
    if @unique_days[-1] != last_day && last_day - @unique_days[-1] > @result
      return [@unique_days[-1], last_day]
    end

    @gap_list
  end

  def calculate_gap
    @unique_days.each_with_index do |day, i|
      next if i + 1 == @unique_days.length
      gap = (day - @unique_days[i + 1]).abs - 1

      if gap > @result
        @gap_index = i
        @result = gap
      end
    end

    [@unique_days[@gap_index] + 1, @unique_days[@gap_index + 1]]
  end

  def create_data_array(username, user_id)
    if @which
      count = fetch_closed_contracts(user_id, @current_report.id).count
      [username, count, @sum, (count.to_f / find_business_days.to_f).round(1),
       ((@sum / @current_report.goal) * 100).round(1), @day_gap]
    else
      [username, @sum, (@sum.to_f / find_business_days.to_f).round(1),
       ((@sum / @current_report.goal) * 100).round(1), @day_gap]
    end
  end

  def start_record_points
    @last_day = month_days
  end

  def fetch_record_points(type)
    fetch_user_by_individual_goal(@current_report.id).collect do |user|
      next if verify_fetched_points(user.id)

      @list = []
      @sum = 0

      prepare_points(user.id)
      organize_data(user.id) unless @unique_days.empty?

      @list
    end
  end

  def verify_fetched_points(user_id)
    @unique_days = if @which
                     fetch_unique_days_contract(user_id, @current_report.id)
                   else
                     fetch_unique_days_meeting(user_id, @current_report.id)
                   end
    @unique_days.empty?
  end

  def prepare_points(_user_id)
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
      add_day_sum(day + @gap[i], user_id) if i < @gap.length && @gap[i] != 0
    end
  end

  def calculate_delta_gap
    aux = []
    length = @unique_days.length

    @unique_days.each_with_index { |day, i| add_gap(aux, day, i) if length > 1 }
    finish_search(aux)
  end

  def add_day_sum(day, u_id, can = false, r_id = @current_report.id)
    search_record_points(day, u_id, r_id) if can
    @list << [day, @sum]
  end

  def add_gap(list, day, index, length = @unique_days.length)
    list << (day - @unique_days[index + 1]).abs - 1 if index + 1 < length
  end

  def search_record_points(day, u_id, r_id)
    return @sum += fetch_meeting_sum(u_id, r_id, day) unless @which
    fetch_contracts(day, r_id, u_id).map { |con| @sum += con.value.to_f }
  end

  def finish_search(gap_list)
    last_day = fetch_last_day
    gap_list << (last_day - @unique_days[-1]) if @unique_days[-1] != last_day
    gap_list.unshift(@unique_days[0] - 2) if @unique_days[0] != 1

    gap_list
  end
end
