module OverviewHelper
  def remove_previous_months_first(type)
    index = @first_list.find_index(fetch_report('July', 2017, type))
    @first_list = @first_list[0..index]
    @first_list.pop
  end

  def remove_previous_months_last(type)
    index = @last_list.find_index(fetch_report('July', 2017, type))
    @last_list = @last_list[0..index]
    @last_list.pop
  end

  def fetch_first_list
    @first_list.unshift(@first_list.delete_at(11)) if @first_list.count >= 12
  end

  def prepare_lists
    @first = params[:report][:month].split('/')
    @last = params[:report][:year].split('/')
  end

  def fecth_normal_list(type)
    prepare_lists
    @first_list.unshift(
      @first_list.delete(fetch_report(@first[0], @first[1], type))
    )
    @last_list.unshift(@last_list.delete(fetch_report(@last[0], @last[1], type)))
  end

  def greater_month
    @first_report.month_numb < @last_report.month_numb
  end

  def greater_year
    @first_report.year > @last_report.year
  end

  def same_year
    @first_report.year == @last_report.year
  end

  def switch
    @first_report, @last_report = @last_report, @first_report
  end

  def verify_dates
    switch if (same_year && !greater_month) || greater_year
  end
end
