module GraphicHelper
  def day_text_generator
    (1..month_days).collect { |day| [day, day.to_s] }
  end

  def month_text_generator
    @month_text = []
    report = @first_report
    i = 1
    while proceed?(report)
      add_month_text(i, report)
      report = fetch_report_by_next_month(report)
      i += 1
    end
    add_month_text(i, report)
  end

  def add_month_text(index, report)
    @month_text << [index, report.month[0..2] + '/' + report.year.to_s[2..3]]
  end

  def proceed?(report)
    !report.nil? && report.id != @last_report.id
  end

  def init_month_year
    @month_year = params[:report].nil? ? fetch_default_data : fetch_custom_data
    list = @month_year.split('/')

    @month = list[0]
    @year = list[1]
  end

  def fetch_custom_data
    params[:report][:month] + '/' + params[:report][:year].to_s
  end

  def init_overview_options_list
    @user_options = [['All Salesman', 'All']] +
                    fetch_username_by_salesman_priority.collect do |username|
                      [username, username]
                    end
    @filter_options = [['Contract Sum', 'CS'], ['Contracts Closed', 'CC'],
                       ["Goal's Percentage", 'CP']]
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
end
