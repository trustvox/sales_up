module GraphicHelper
  def day_text_generator
    (1..month_days).collect { |day| [day, day.to_s] }
  end

  def wday_text_generator
    date = Date.new(@current_report.year, @current_report.month_numb, 1) - 1

    (1..month_days).collect do |day|
      date += 1
      [day, t('menu.spreadsheet.' + Date::DAYNAMES[date.wday])[0]]
    end
  end

  def month_text_generator(type)
    @month_text = []
    report = @first_report
    i = 1

    while proceed?(report)
      add_month_text(i, report)
      report = fetch_report_by_next_month(report, type)
      i += 1
    end

    add_month_text(i, report)
  end

  def add_month_text(index, report)
    @month_text << [index, t('menu.search.' + report.month)[0..2] + '/' +
                           report.year.to_s[2..3]]
  end

  def proceed?(report)
    !report.nil? && report.id != @last_report.id
  end

  def init_overview_options_list(type)
    list = if type == 'AM'
             [[t('overview.AM.cs'), 'CS'],
              [t('overview.AM.cc'), 'CC'],
              [t('overview.AM.cp'), 'CP']]
           else
             [[t('overview.SDR.ms'), 'MS'],
              [t('overview.SDR.mp'), 'MP']]
           end

    create_options_list(type, list)
  end

  def create_options_list(type, list)
    @user_options =
      [[t('overview.' + type + '.all'), 'All']] +
      fetch_username_by_sub_area(type).collect { |user| [user, user] }
    @filter_options = list
  end

  def verify_filter
    @filter_options.each do |op|
      next unless op[1] == params[:report][:goal]

      @filter_options.delete(op)
      @filter_options.unshift(op)
    end
  end

  def verify_user
    @user_options.each do |op|
      next unless op[1] == params[:report][:report_name]

      @user_options.delete(op)
      @user_options.unshift(op)
    end
  end

  def verify_options
    verify_filter

    return if params[:report][:report_name] == 'All'

    verify_user
  end

  def find_weekdays
    (@first..@last).collect { |date| verify_weekday(date) }
  end

  def verify_weekday(date)
    return 'Monday' if date.monday?
    return 'Tuesday' if date.tuesday?
    return 'Wednesday' if date.wednesday?
    return 'Thursday' if date.thursday?
    return 'Friday' if date.friday?
    
    verify_weekend(date)
  end

  def verify_weekend(date)
    date.saturday? ? 'Saturday' : 'Sunday'
  end
end
