class HomeController < ApplicationController
	before_action :authenticate_user!
	skip_before_action :verify_authenticity_token

	$report_list = []
	Report.find_each do |report|
		$report_list << report
	end
	
	$current_report = nil
	$current_report_data = []
	$current_report_data_points = ""

  def login
  	$current_report = Report.first
		calculate_data
		redirect_to graphic_path
  end

	def graphic
		if $current_report == nil
			$current_report = Report.first
			calculate_data
		end
	end

	def spreadsheet
		if $current_report == nil
			$current_report = Report.first
			calculate_data
		end
	end

	def searchS
		$current_report = Report.find_by_month(params[:months])
		calculate_data
		redirect_to spreadsheet_path
	end

	def searchG
		$current_report = Report.find_by_month(params[:months])
		calculate_data
		redirect_to graphic_path
	end

	private

	def calculate_data
		$current_report_data.clear
		$current_report_data_points = "[ "

		calculate_report_data
		calculate_report_points
	end

	def find_business_days(_first_day, _last_day)
	  business_days = 0
	  current_date = _last_day
	  while current_date > _first_day
	    business_days = business_days + 1 unless current_date.saturday? or current_date.sunday?
	    current_date = current_date - 1.day
	  end
	  business_days
	end

	def find_weekdays(_last_day)
		list = []
		for i in 1.._last_day
			list << which_weekday(Date.strptime($current_report.month_numb.to_s + "/" + i.to_s + "/" + $current_report.year.to_s, '%m/%d/%Y'))
		end
		list
	end

	def which_weekday(_current_date)
		if _current_date.sunday?
			"Sunday"
		elsif _current_date.monday?
			"Monday"
		elsif _current_date.tuesday?
			"Tuesday"
		elsif _current_date.wednesday?
			"Wednesday"
		elsif _current_date.thursday?
			"Thursday"
		elsif _current_date.friday?
			"Friday"
		else
			"Saturday"
		end
	end

	def search_contracts(_contract_list, _index, _current_day)
		partial_sum = 0
		partial_vendor_names = ""
		partial_store_names = ""
		value = 1
		while _contract_list[_index] != nil && _contract_list[_index].day == _current_day
      partial_sum += _contract_list[_index].value
			partial_vendor_names += value.to_s + "-" + User.find_by_id(_contract_list[_index].user_id).full_name + ", "
			partial_store_names += value.to_s + "-" + _contract_list[_index].store_name + ", "
			_index += 1
			value += 1
		end

		list = [_index, partial_sum, partial_store_names, partial_vendor_names]
		list
	end

	def calculate_report_data
		month_days = Time.days_in_month $current_report.month_numb
		weekdays = find_weekdays month_days

		first_date = Date.strptime($current_report.month_numb.to_s + "/1/" + $current_report.year.to_s, '%m/%d/%Y')
		last_date = Date.strptime($current_report.month_numb.to_s + "/" + month_days.to_s + "/" + $current_report.year.to_s, '%m/%d/%Y')

		const = ($current_report.goal / find_business_days(first_date, last_date)).round 2
		value = const
		factor = 2

		contract_sum = 0
		contracts_data_index = 0
		contracts_data = Contract.where(:report_id => $current_report.id).order('day')

    for day in 1..month_days
    	day_data = [] # day_data[0] = day - day_data[1] = weekday - day_data[2] = daily goal - day_data[3] = contract sum
    	              # day_data[4] = store name - day_data[5] = contract value - day_data[6] = salesman name
    	
    	date = Date.strptime($current_report.month_numb.to_s + "/" + day.to_s + "/" + $current_report.year.to_s, '%m/%d/%Y')
      day_data << day.to_s
      day_data << weekdays[day-1]

	    if day != 1 && date.on_weekday?
	      value = const * factor
	    	factor += 1
	    end
	    day_data << value.to_s

			if not contracts_data.empty?
		    if contracts_data[contracts_data_index].day == day
		    	if contracts_data[contracts_data_index+1].day == day
		    		partial_list = search_contracts contracts_data, contracts_data_index, day

		    		contracts_data_index = partial_list[0]
		    		contract_sum += partial_list[1]

		    		day_data[3] = contract_sum
		    		day_data[4] = partial_list[2]
		    		day_data[5] = partial_list[1]
		    		day_data[6] = partial_list[3]

		    	else
		    		contracts_data_index += 1
		    		contract_sum += contracts_data[contracts_data_index].value

		    		day_data[3] = contract_sum
		    		day_data[4] = contracts_data[contracts_data_index].store_name
		    		day_data[5] = contracts_data[contracts_data_index].value
		    		day_data[6] = User.find_by_id(contracts_data[contracts_data_index].user_id).full_name
		    	end
				end
	    else
		    day_data[3] = 0
	  		day_data[4] = "-"
	  		day_data[5] = 0
	  		day_data[6] = "-"
	  	end

      $current_report_data << day_data
    end
	end

	def calculate_report_points
    wait_for_sunday = false
    last_save = []

    for day_data in $current_report_data
    	if not wait_for_sunday
	    	if day_data[0] == "1"
	    		$current_report_data_points += "[" + day_data[0] + "," + day_data[2] + "]"
	    	  wait_for_sunday = true if day_data[1] == "Friday" || day_data[1] == "Saturday"
	    	elsif day_data[1] == "Friday"
	    		$current_report_data_points += ", [" + day_data[0] + "," + day_data[2] + "]"
	    	  wait_for_sunday = true
	    	  last_save = day_data
	    	end
    	elsif day_data[1] == "Sunday"
  			$current_report_data_points += ", [" + day_data[0] + "," + day_data[2] + "]"
  			wait_for_sunday = false
  			last_save = day_data
  		end
  	end
    
  	if $current_report_data[-1][0] != last_save[0]
  		$current_report_data_points += ", [" + $current_report_data[-1][0] + "," + $current_report_data[-1][2] + "]"
		end
		$current_report_data_points += "]"
	end
end