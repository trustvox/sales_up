class HomeController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  $current_report = nil
  $current_report_data = []
  $current_report_points = ''

  $current_contracts_data = []
  $current_contract_points = ''

  def login
    calculate_data Report.first
    if params[:where] == 'spreadsheet'
      redirect_to spreadsheet_path
    else
      redirect_to graphic_path
    end
  end

  def graphic
    verify_current_report
  end

  def spreadsheet
    verify_current_report
  end

  def search
    request = params[:month].split '/'
    calculate_data Report.where(month: request[0], year: request[1])[0]
    if params[:where] == 'spreadsheet'
      redirect_to spreadsheet_path
    else
      redirect_to graphic_path
    end
  end

  private

  def verify_current_report
    calculate_data Report.first if $current_report.nil?
  end

  def calculate_data(_new_report)
    $current_report = _new_report

    $current_report_data.clear
    $current_report_points = '[ '

    $current_contracts_data.clear
    $current_contract_points = '[ '

    unless Contract.where(report_id: $current_report.id).order('day').empty?
      calculate_contract_data
      calculate_contract_points
    end

    $current_contract_points += ']'
    calculate_report_data
    calculate_report_points
  end

  def find_business_days(_first_date, _last_date)
    business_days = 1
    current_date = _last_date
    while current_date > _first_date
      business_days += 1 unless current_date.saturday? || current_date.sunday?
      current_date -= 1.day
    end
    business_days
  end

  def find_weekdays(_last_day)
    list = []
    for i in 1.._last_day
      list << which_weekday(Date.strptime($current_report.month_numb.to_s + '/' + i.to_s + '/' + $current_report.year.to_s, '%m/%d/%Y'))
    end
    list
  end

  def which_weekday(_current_date)
    if _current_date.sunday?
      'Sunday'
    elsif _current_date.monday?
      'Monday'
    elsif _current_date.tuesday?
      'Tuesday'
    elsif _current_date.wednesday?
      'Wednesday'
    elsif _current_date.thursday?
      'Thursday'
    elsif _current_date.friday?
      'Friday'
    else
      'Saturday'
    end
  end

  def calculate_contract_data
    contract_search = Contract.where(report_id: $current_report.id).order('day')

    contract_data = [] # contract_data[0] = day - contract_data[1] = contracts sum - contract_data[2] = store name
    # contract_data[3] = partial contract sum - contract_data[4] = salesman name
    contracts_sum = 0
    partial_contract_sum = 0
    partial_vendor_name = ''
    partial_store_name = ''
    value = 1
    wait = false

    for i in 0..contract_search.length - 1
      if i + 1 < contract_search.length && contract_search[i].day == contract_search[i + 1].day
        contracts_sum += contract_search[i].value
        partial_contract_sum += contract_search[i].value
        partial_store_name += value.to_s + '-' + contract_search[i].store_name + '; '
        partial_vendor_name += value.to_s + '-' + User.find_by_id(contract_search[i].user_id).full_name + '; '

        value += 1
        wait = true
      elsif wait
        contract_data << contract_search[i - 1].day
        contract_data << contracts_sum
        contract_data << partial_store_name[0, partial_store_name.length - 3]
        contract_data << partial_contract_sum
        contract_data << partial_vendor_name[0, partial_vendor_name.length - 3]

        partial_contract_sum = 0
        partial_vendor_name = ''
        partial_store_name = ''
        value = 1
        wait = false

        $current_contracts_data << contract_data
        contract_data = []
      else
        contracts_sum += contract_search[i].value
        contract_data << contract_search[i].day
        contract_data << contracts_sum
        contract_data << contract_search[i].store_name
        contract_data << contract_search[i].value
        contract_data << User.find_by_id(contract_search[i].user_id).full_name

        $current_contracts_data << contract_data
        contract_data = []
      end
    end
  end

  def calculate_report_data
    month_days = Time.days_in_month $current_report.month_numb
    weekdays = find_weekdays month_days

    first_date = Date.strptime($current_report.month_numb.to_s + '/1/' + $current_report.year.to_s, '%m/%d/%Y')
    last_date = Date.strptime($current_report.month_numb.to_s + '/' + month_days.to_s + '/' + $current_report.year.to_s, '%m/%d/%Y')

    const = ($current_report.goal / find_business_days(first_date, last_date)).round 2
    value = const
    factor = 2
    data_index = 0

    for day in 1..month_days
      day_data = [] # day_data[0] = day - day_data[1] = weekday - day_data[2] = daily goal - day_data[3] = contract sum
      # day_data[4] = store name - day_data[5] = contract value - day_data[6] = salesman name

      date = Date.strptime($current_report.month_numb.to_s + '/' + day.to_s + '/' + $current_report.year.to_s, '%m/%d/%Y')
      day_data << day.to_s
      day_data << weekdays[day - 1]

      if day != 1 && date.on_weekday?
        value = const * factor
        factor += 1
      end
      day_data << value.to_s

      if $current_contracts_data.empty?
        day_data << 0
        day_data << '-'
        day_data << 0
        day_data << '-'
      else
        if $current_contracts_data[data_index][0] == day
          day_data << $current_contracts_data[data_index][1]
          day_data << $current_contracts_data[data_index][2]
          day_data << $current_contracts_data[data_index][3]
          day_data << $current_contracts_data[data_index][4]
          data_index += 1 unless (data_index + 1) >= $current_contracts_data.length
        else
          day_data << if data_index != 0
                        $current_contracts_data[data_index][1]
                      else
                        0
                      end
          day_data << '-'
          day_data << 0
          day_data << '-'
        end
        end

      $current_report_data << day_data
    end
  end

  def calculate_report_points
    wait_for_sunday = false
    last_save = []

    for day_data in $current_report_data
      if !wait_for_sunday
        if day_data[0] == '1'
          $current_report_points += '[' + day_data[0] + ',' + day_data[2] + ']'
          wait_for_sunday = true if day_data[1] == 'Friday' || day_data[1] == 'Saturday'
        elsif day_data[1] == 'Friday'
          $current_report_points += ', [' + day_data[0] + ',' + day_data[2] + ']'
          wait_for_sunday = true
          last_save = day_data
        end
      elsif day_data[1] == 'Sunday'
        $current_report_points += ', [' + day_data[0] + ',' + day_data[2] + ']'
        wait_for_sunday = false
        last_save = day_data
      end
    end

    if $current_report_data[-1][0] != last_save[0]
      $current_report_points += ', [' + $current_report_data[-1][0] + ',' + $current_report_data[-1][2] + ']'
    end

    $current_report_points += ']'
  end

  def calculate_contract_points
    $current_contract_points += '[1,0]'

    for contract_data in $current_contracts_data
      $current_contract_points += ', [' + contract_data[0].to_s + ',' + contract_data[1].to_s + ']'
    end
  end
end
