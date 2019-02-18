module OverviewHelper
  DATE = ['July', 2017].freeze

  def fetch_overview_search_bar_list(which, type)
    list = all_date_list(type)
    remove_previous_month(list, type) if type == 'am'

    return remove_first_value(list) if params[:report].nil?

    remove_current_value(list, which, type)
  end

  def remove_previous_month(list, type)
    index = list.find_index(fetch_report(DATE[0], DATE[1], type))
    list = list[0..index]
    list.pop
  end

  def remove_first_value(list)
    list.unshift(list.delete_at(list.count >= 12 ? 11 : -1))

    list
  end

  def prepare_lists(which)
    return params[:report][:month].split('/') if which == 'first'

    params[:report][:year].split('/')
  end

  def remove_current_value(list, which, type)
    data = prepare_lists(which)
    list.unshift(list.delete(fetch_report(data[0], data[1], type)))

    list
  end

  def wrong_month_year?(first, last)
    first.year == last.year && first.month_number >= last.month_number
  end

  def valid_report_data?(first, last)
    wrong_month_year?(first, last) || first.year > last.year
  end

  def fetch_sum(id, type)
    sum = 0

    if type == 'am'
      fetch_contract_by_report_id(id).each { |cont| sum += cont.value.to_f }
    else
      fetch_meeting_by_report_id(id).each { |_meet| sum += 1 }
    end

    sum.to_s
  end

  def init_filter(type)
    if params[:report].nil?
      type == 'am' ? (return 'CS') : (return 'MS')
    end

    params[:report][:goal]
  end

  def init_symbol_with_filter(type)
    case init_filter(type)
    when 'CS'
      t('graphic.currency') + ' %y.2'
    when 'CC'
      '%y ' + t('graphic.contract')
    when 'MS'
      '%y ' + t('graphic.meeting')
    else
      '%y.2%'
    end
  end

  def init_username_data(type)
    return fetch_username_by_sub_area(type) if valid_report_data_for_overview?

    [params[:report][:report_name]]
  end

  def valid_report_data_for_overview?
    params[:report].nil? || params[:report][:report_name] == 'All'
  end
end
