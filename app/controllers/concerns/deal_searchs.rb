module DealSearchs
  def fetch_deal_by_report_id(report_id)
    Deal.where(report_id: report_id).order('day')
  end

  def destroy_deal_by_id(deal_id)
    Deal.find_by(id: deal_id).destroy
  end

  def fetch_deals(day, report_id, user_id)
    Deal.where(day: day, report_id: report_id, user_id: user_id)
  end

  def fetch_deals_by_day_report_id(day, report_id)
    Deal.where(day: day, report_id: report_id)
  end

  def fetch_deals_by_user_report_id(user_id, report_id)
    Deal.where(user_id: user_id, report_id: report_id).count
  end

  def fetch_deal_sum_with_ids(user_id, report_id)
    values = 0
    deals = fetch_sent_deals_with_report_user(user_id, report_id)
    deals.each { |deal| values += deal.value.to_f }

    values
  end

  def fetch_deal_sum(report_id)
    values = 0
    deals = fetch_sent_deals_with_report(report_id)
    deals.each { |deal| values += deal.value.to_f }

    values
  end

  def fetch_unique_days_deal(user_id, report_id)
    fetch_sent_deals_with_report_user(user_id, report_id).distinct.pluck(:day)
  end

  def fetch_sent_deals_with_report_user(user_id, report_id)
    Deal.where(user_id: user_id, report_id: report_id).order('day')
  end

  def fetch_sent_deals_with_report(report_id)
    Deal.where(report_id: report_id).order('day')
  end

  def fetch_deal_by_store_name(store_name)
    Deal.find_by(store_name: store_name)
  rescue StandardError
    nil
  end
end
