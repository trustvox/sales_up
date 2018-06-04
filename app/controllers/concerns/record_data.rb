module RecordData
  def initialize
    @record_data = []
    @current_report = nil
  end

  def start_record_data(report)
    @current_report = report
  end

  def fetch_record_data
    fetch_user_by_priority(1).collect do |user|
      prepare_data(user.id)

      [user.full_name, @closed_contracts.count, @sum,
       (@closed_contracts.count.to_f / @unique_days.to_f).round(1),
       ((@sum / @current_report.goal) * 100).round(1)]
    end
  end

  def prepare_data(user_id)
    @closed_contracts = fetch_closed_contracts(user_id)
    @sum = fetch_contract_sum(@closed_contracts)
    @unique_days = @closed_contracts.distinct.pluck(:day).count
  end

  def fetch_closed_contracts(user_id)
    fetch_contracts_by_user_report_id(user_id, @current_report.id)
  end

  def fetch_contract_sum(contracts)
    values = 0
    contracts.each { |contract| values += contract.value }
    values
  end
end
