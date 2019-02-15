module OverviewPoints
  include DatabaseSearchs
  include OverviewHelper

  def init_report_data(which, type, data)
    if data.blank?
      last = fetch_last_report(type)
      return last if which == 'last'
      
      reports_count = fetch_report_count_by_type(type)
      range = reports_count < 12 ? reports_count : 12

      return fetch_reports_by_month_range(last, type, range)
    end
    fetch_report(data[0], data[1], type)
  end

  def overview_data(which, type, month = nil, year = nil)
    first = init_report_data('first', type, month)
    last = init_report_data('last', type, year)
    
    first, last = last, first if valid_report_data?(first, last)

    if which == 'm' 
      overview_month_data(first, last, type) 
    else
      overview_report_data(first, last, type) 
    end
  end

  def overview_month_data(first, last, type)
    i = 1

    while acceptable?(first, last)
      add_goal_sum(i, first, type)
      first = verify_next_month(first, type)
      i += 1
    end

    add_goal_sum(i, first, type)
  end

  def acceptable?(first, last)
    !first.nil? && (first.month_number != last.month_number || first.year != last.year)
  end

  def add_goal_sum(index, first, type)
    @goal_points << [index, first.goal.to_f]
    @am_points << [index, fetch_sum(first.id, type)]
  end

  def verify_next_month(first, type)
    fetch_report_by_next_month(first, type)
  end

  def init_user_data(type)
    return fetch_user_by_sub_area(type) if valid_report_data_for_overview?

    fetch_user_by_username(params[:report][:report_name])
  end

  def overview_report_data(first, last, type)
    i = 1
    report = first

    init_user_data(type).collect do |user|
      list = []
      
      while acceptable?(first, last)
        list << verify_filter_option(user.id, i, first, type)
        first = verify_next_month(first, type)
        i += 1
      end

      list << verify_filter_option(user.id, i, first, type)
      first = report
      i = 1

      list
    end
  end

  def verify_filter_option(id, index, first, type)
    if type == 'am' 
      am_filter(id, index, first, type) 
    else
      sdr_filter(id, index, first, type)
    end
  end

  def am_filter(user_id, index, first, type)
    case init_filter(type)
    when 'CS'
      [index, fetch_contract_sum(user_id, first.id)]
    when 'CP'
      sum = fetch_contract_sum(user_id, first.id)
      [index, ((sum / fetch_goal_by_id(first.id)) * 100).round(1)]
    when 'CC'
      [index, fetch_contracts_by_user_report_id(user_id, first.id)]
    end
  end

  def sdr_filter(user_id, index, first, type)
    case init_filter(type)
    when 'MS'
      [index, fetch_meeting_sum(user_id, first.id)]
    when 'MP'
      sum = fetch_meeting_sum(user_id, first.id)
      [index, ((sum / fetch_goal_by_id(first.id)) * 100).round(1)]
    end
  end
end
