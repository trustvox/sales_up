module GraphicHelper
  def day_text_generator
    (1..month_days).collect { |day| [day, day.to_s] }
  end

  def wday_text_generator
    date = Date.new(@current_report.year, @current_report.month_number, 1) - 1

    (1..month_days).collect do |day|
      date += 1
      [day, t('menu.spreadsheet.' + Date::DAYNAMES[date.wday])[0]]
    end
  end

  def month_text_generator(first, last, type)
    month_text = []
    i = 1

    while proceed?(first, last)
      month_text << add_month_text(i, first)
      first = fetch_report_by_next_month(first, type)
      i += 1
    end

    month_text << add_month_text(i, first)

    month_text
  end

  def add_month_text(ind, report)
    [ind, t('menu.search.' + report.month)[0..2] + '/' + report.year.to_s[2..3]]
  end

  def proceed?(report, last)
    !report.nil? && report.id != last.id
  end

  def init_user_options(type)
    user_options = [[t('overview.' + type + '.all'), 'All']] +
                   fetch_username_by_sub_area(type)
                   .collect { |user| [user, user] }

    return user_options if valid_report_data_for_user?

    verify_options_data(user_options, params[:report][:report_name])
  end

  def init_filter_options(_type)
    filter_options = fetch_options_array

    return filter_options if valid_report_data_for_filter?

    verify_options_data(filter_options, params[:report][:goal])
  end

  def fetch_options_array
    if type == 'am'
      return [[t('overview.am.cs'), 'CS'], [t('overview.am.cc'), 'CC'],
              [t('overview.am.cp'), 'CP'], [t('overview.am.fc'), 'FC']]
    end

    [[t('overview.sdr.ms'), 'MS'], [t('overview.sdr.mp'), 'MP']]
  end

  def verify_options_data(options, verificator)
    options.each do |op|
      next unless op[1] == verificator

      options.delete(op)
      options.unshift(op)
    end

    options
  end

  def find_weekdays
    (@first..@last).collect { |date| verify_weekday(date) }
  end

  def verify_weekday(date)
    %w[Sunday Monday Tuesday Wednesday
       Thursday Friday Saturday].each_with_index do |day, i|
      return day if date.wday == i
    end
  end
end
