module IntegrationHelper
  def create_schedule_helper
    @meet = Meeting.new
    user = fetch_user_by_email(params[:sdr_name])

    fetch_schedule_client_and_day
    fetch_schedule_data_for(user)
    fetch_schedule_ids(user)

    @meet.save if @meet.valid?
  end

  def fetch_schedule_client_and_day
    @meet.client_name = verify_client_name
    @meet.day = Time.current.day
  end

  def fetch_schedule_data_for(user)
    @meet.scheduled_for = params[:schedule_date].tr(',', '')
    @meet.meeting_for = verify_meeting_for(user)
  end

  def fetch_schedule_ids(user)
    @meet.user_id = user.id
    @meet.report_id = fetch_last_report('sdr').id
  end

  def verify_client_name
    client = params[:client_name].split('>')[-1]

    return unless fetch_meeting_by_client_name(client).nil?

    client
  end

  def verify_meeting_for(user)
    return user.full_name if user.am?

    fetch_user_by_email(params[:am_name].split(',')[0]).full_name
  end

  def create_contract_helper
    @contract = Contract.new

    fetch_contract_day_store_and_value
    fetch_contract_ids

    @contract.save if @contract.valid?
  end

  def fetch_contract_day_store_and_value
    @contract.day = Time.current.day
    @contract.value = params[:value]
    @contract.store_name = params[:store_name]
  end

  def fetch_contract_ids
    @contract.report_id = fetch_last_report('am').id
    @contract.user_id = fetch_user_by_username(params[:am_name])[0].id
  end

  def create_deal_helper
    search_deal = fetch_deal_by_client(params[:client_name])

    change_deal(search_deal.nil? ? Deal.new : search_deal)
  end

  def change_deal(deal)
    @deal = deal
    date = params[:date].split('/')

    fetch_deal_ids(date)
    fetch_deal_day_client_and_value(date)

    @deal.save if @deal.valid?
  end

  def fetch_deal_ids(date)
    @deal.user_id = fetch_user_by_email(params[:am_email]).id
    @deal.report_id =
      fetch_report_with_month_number(date[1][-1], date[2], SIDES[0]).id
  end

  def fetch_deal_day_client_and_value(date)
    @deal.day = date[0]
    @deal.value = params[:value][0..-4].delete('.')
    @deal.client_name = params[:client_name]
  end
end
