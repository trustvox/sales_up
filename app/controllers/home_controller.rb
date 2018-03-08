class HomeController < ApplicationController
	before_action :authenticate_user!
	skip_before_action :verify_authenticity_token

	$report_list = []
	Report.find_each do |report|
		$report_list << report
	end
	
	$current_report = Report.first

	def graphic
		
	end

	def spreadsheet
		@month_days = Time.days_in_month $current_report.month_numb
		@business_days = find_business_days Date.strptime($current_report.month_numb.to_s + "/1/2018", '%m/%d/%Y'), 
		                               Date.strptime($current_report.month_numb.to_s + "/" + @month_days.to_s + "/2018", '%m/%d/%Y')
		@weekdays = find_weekdays(@month_days)
	end

	def searchS
		$current_report = Report.find_by_month(params[:months])
		redirect_to spreadsheet_path
	end

	def searchG
		$current_report = Report.find_by_month(params[:months])
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
			list << which_weekday(Date.strptime($current_report.month_numb.to_s + "/" + i.to_s + "/2018", '%m/%d/%Y'))
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
end