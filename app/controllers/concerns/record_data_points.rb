module RecordDataPoints
  def initialize
    @record_data = []
    @current_report = nil
  end

  def start_record_data(report)
    @current_report = report
    @last_day = month_days
  end

  def fetch_record_data
    fetch_user_by_priority(1).collect do |user|
      prepare_data(user.id)

      unless @closed_contracts.empty?
        [user.full_name, @closed_contracts.count, @sum,
         (@closed_contracts.count.to_f / @unique_days.count.to_f).round(1),
         ((@sum / @current_report.goal) * 100).round(1), @day_gap]
      else
        nil
      end
    end
  end

  def prepare_data(user_id)
    @closed_contracts = fetch_closed_contracts(user_id)

    unless @closed_contracts.empty?
      @sum = fetch_contract_sum(@closed_contracts)
      @unique_days = @closed_contracts.distinct.pluck(:day)
      @day_gap = calculate_delta_gap.sort[-1]
    end
  end

  def fetch_closed_contracts(user_id)
    fetch_contracts_by_user_report_id(user_id, @current_report.id)
  end

  def fetch_contract_sum(contracts)
    values = 0
    contracts.each { |contract| values += contract.value }
    values
  end

  def start_record_points(report)
    @current_report = report
    @last_day = month_days
  end

  def fetch_record_points
    fetch_user_by_priority(1).collect do |user|
      @list = []
      @sum = 0

      prepare_points(user.id)
      organize_data unless @unique_days.empty?

      @list unless @unique_days.empty?
    end
  end

  def prepare_points(user_id)
    @unique_days = fetch_closed_contracts(user_id).distinct.pluck(:day)

    unless @unique_days.empty?
      @last_day = month_days
      @gap = calculate_delta_gap
    end
  end

  def organize_data
    if @unique_days[0] != 1
      @list << [1, 0]
      @list << [1 + @gap[0], 0]
      @gap.shift
    end

    @unique_days.each_with_index do |day, i|
      #knjlwgb if day == 9
      contract_sum_in_day(day)
      @list << [day, @sum]
      @list << [day + @gap[i], @sum] if i < @gap.length && @gap[i] != 0
    end

    @list << [@last_day, @sum] if @unique_days[-1] != @last_day
  end

  def contract_sum_in_day(day)
    fetch_contracts_by_day_report_id(day, @current_report.id).map do |cont|
      @sum += cont.value.to_f
    end
  end

  def calculate_delta_gap
    gap_list = []

    if @unique_days.length > 1
      @unique_days.each_with_index do |day, i|
        gap_list << (day - @unique_days[i+1]).abs-1 if i+1 < @unique_days.length
      end
    end

    finish_search(gap_list)
  end

  def finish_search(gap_list)
    gap_list << (@last_day - @unique_days[-1]) if @unique_days[-1] != @last_day
    gap_list.unshift(@unique_days[0] - 2) if @unique_days[0] != 1

    gap_list
  end
end
