module ViewHelper
  def fetch_line_name
    @record_data.collect { |data| data[0] }
  end

  def init_month_year_list
    month_year_list = all_date_list(@current_report.goal_type)
    month_year_list.delete(@current_report)
    month_year_list.unshift(@current_report)

    month_year_list
  end

  def init_current_report(type)
    @current_report = if params[:report].nil?
                        fetch_last_report(type)
                      else
                        fetch_report(params[:report][:month],
                                     params[:report][:year], type)
                      end
  end

  def init_page_title(type)
    [t('menu.' + action_name), t('menu.sales_side') + '-' +
      t('menu.' + type + '_side'), type]
  end

  def redirect_to_monthly_method(id, errors, method_name, action = nil)
    report = fetch_report_by_id(id)
    message = errors.messages.map { |msg| msg[1] }

    redirect_to controller: 'dashboard', action: 'monthly_' + method_name,
                'report[month]' => report.month,
                'report[year]' => report.year,
                notice: message + [[action]]
  end
end
