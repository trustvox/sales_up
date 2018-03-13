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
		
	end

	def spreadsheet
		
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

	def calculate_report_data
		month_days = Time.days_in_month $current_report.month_numb
		weekdays = find_weekdays month_days

		first_date = Date.strptime($current_report.month_numb.to_s + "/1/" + $current_report.year.to_s, '%m/%d/%Y')
		last_date = Date.strptime($current_report.month_numb.to_s + "/" + month_days.to_s + "/" + $current_report.year.to_s, '%m/%d/%Y')

		const = ($current_report.goal / find_business_days(first_date, last_date)).round 2
		value = const
		factor = 2

    for day in 1..month_days
    	day_data = [] # day_data[0] = day - day_data[1] = weekday - day_data[2] = daily goal
    	
    	date = Date.strptime($current_report.month_numb.to_s + "/" + day.to_s + "/" + $current_report.year.to_s, '%m/%d/%Y')
      day_data << day.to_s
      day_data << weekdays[day-1]

	    if day != 1 && date.on_weekday?
	      value = const * factor
	    	factor += 1
	    end

	    day_data << value.to_s
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