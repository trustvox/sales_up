class HomeController < ApplicationController
	before_action :authenticate_user!
	skip_before_action :verify_authenticity_token

	$report_list = []
	Report.find_each do |report|
		$report_list << report
	end
	
	$current_report = Report.first
	$current_report_data = []

	def graphic
		calculate_report_data unless $current_report_data.any?
	end

	def spreadsheet
		
	end

	def searchS
		$current_report = Report.find_by_month(params[:months])
		calculate_report_data
		redirect_to spreadsheet_path
	end

	def searchG
		$current_report = Report.find_by_month(params[:months])
		calculate_report_data
		redirect_to graphic_path
	end

	private

	def find_business_days(date1, date2)
	  business_days = 0
	  date = date2
	  while date > date1
	    business_days = business_days + 1 unless date.saturday? or date.sunday?
	    date = date - 1.day
	  end
	  business_days
	end

	def find_weekdays(finalDay)
		list = []
		for i in 1..finalDay
			list << which_weekday(Date.strptime($current_report.month_numb.to_s + "/" + i.to_s + "/" + $current_report.year.to_s, '%m/%d/%Y'))
		end
		list
	end

	def which_weekday(date)
		if date.sunday?
			"Sunday"
		elsif date.monday?
			"Monday"
		elsif date.tuesday?
			"Tuesday"
		elsif date.wednesday?
			"Wednesday"
		elsif date.thursday?
			"Thursday"
		elsif date.friday?
			"Friday"
		else
			"Saturday"
		end
	end

	def calculate_report_data
		$current_report_data.clear

		month_days = Time.days_in_month $current_report.month_numb
		weekdays = find_weekdays month_days

		first_date = Date.strptime($current_report.month_numb.to_s + "/1/" + $current_report.year.to_s, '%m/%d/%Y')
		last_date = Date.strptime($current_report.month_numb.to_s + "/" + month_days.to_s + "/" + $current_report.year.to_s, '%m/%d/%Y')

		value = ($current_report.goal / find_business_days(first_date, last_date)).round 2
		factor = 2

    for i in 1..month_days
    	data = [] # data[0] = day - data[1] = weekday - data[2] = daily goal
      date = Date.strptime($current_report.month_numb.to_s + "/" + i.to_s + "/" + $current_report.year.to_s, '%m/%d/%Y')
      data << i.to_s
      data << weekdays[i-1]
    
	    if i == 1.to_i  
	      data << value.to_s
	    elsif date.on_weekend?
	      data << "-"
	    else
	      data << (value * factor).to_s
	      factor += 1
	    end

	    $current_report_data << data
	  end
	end

	def calculate_report_points
		point_list = []

		# coordinate x is the day, coordinate y is the daily goal value
    first_point = [] 
    last_point = [] 

    wait = false
    first_time = true

    for data in $current_report_data
    	if first_time
    		first_point << data[0]      #<-this is coordinate x
    		first_point << data[2].to_f #<-this is coordinate y

    		wait = true if data[1] == "Friday" || data[1] == "Saturday" || data[1] == "Sunday"

    		first_time = false
    	elsif data[1] == "Friday"
    		last_point << data[0]
    		last_point << data[2]
    		wait = true
    	elsif data[1] == "Monday"

    		

    end
	end
end