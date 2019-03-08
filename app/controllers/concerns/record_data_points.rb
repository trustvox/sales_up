module RecordDataPoints
  def type_am?
    @current_report.goal_type == 'am'
  end

  def fetch_record_sum(user_id)
    return fetch_contract_sum_with_ids(user_id, @current_report.id) if type_am?

    fetch_meeting_sum(user_id, @current_report.id)
  end

  def fetch_record_days(user_id)
    @unique_days = if type_am?
                     fetch_unique_days_contract(user_id, @current_report.id)
                   else
                     fetch_unique_days_meeting(user_id, @current_report.id)
                   end
  end

  def fetch_gap
    @result = 0

    fetch_gap_without_weekend(verify_first_last_days(calculate_gap))
  end

  def verify_first_last_days(gap_list)
    if @unique_days[0] != 1 && @unique_days[0] - 1 > @result
      return [1, @unique_days[0]]
    end

    last_day = fetch_last_day
    if @unique_days[-1] != last_day && last_day - @unique_days[-1] > @result
      return [@unique_days[-1], last_day]
    end

    gap_list
  end

  def calculate_gap
    gap_index = 0

    @unique_days.each_with_index do |day, i|
      next if i + 1 == @unique_days.length

      gap = verify_friday_to_monday(day, i)

      if gap > @result
        gap_index = i
        @result = gap
      end
    end

    # verify_current_with_last_day(gap_index)

    [@unique_days[gap_index] + 1, @unique_days[gap_index + 1]]
  end

  def create_data_array(user, gap, sum)
    return data_array_for_sdr(user, gap, sum) unless type_am?

    data_array_for_am(user, gap, sum,
                      fetch_closed_contracts_report_user(
                        user.id, @current_report.id
                      ).count)
  end

  def data_array_for_am(user, gap, sum, count)
    [user.full_name, count, sum,
     (count.to_f / find_business_days(fetch_last_day).to_f).round(1),
     ((sum / @current_report.goal) * 100).round(1), gap]
  end

  def data_array_for_sdr(user, gap, sum)
    [user.full_name, sum, (sum.to_f / find_business_days(fetch_last_day).to_f)
      .round(1), ((sum / @current_report.goal) * 100).round(1), gap]
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

    @unique_days.each_with_index do |day, i|
      add_gap(aux, day, i) if length > 1
    end

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
    return @sum += fetch_meeting_sum(u_id, r_id, day) unless type_am?

    fetch_contracts(day, r_id, u_id).map { |con| @sum += con.value.to_f }
  end

  def finish_search(gap_list)
    last_day = fetch_last_day
    gap_list << (last_day - @unique_days[-1]) if @unique_days[-1] != last_day
    gap_list.unshift(@unique_days[0] - 2) if @unique_days[0] != 1

    gap_list
  end
end
