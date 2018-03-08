class HomeController < ApplicationController
	before_action :authenticate_user!

	def graphic
		@report = Report.first
	end

	def spreadsheet
		@report = Report.last
		@month_days = Time.days_in_month(@report.month)
		@business_days = business_days Date.strptime(@report.month.to_s+"/1/2018", '%m/%d/%Y'), 
		                               Date.strptime(@report.month.to_s+"/"+@month_days.to_s+"/2018", '%m/%d/%Y')
		@weekdays = weekdays(@month_days)
	end

	private

	def business_days(date1, date2)
	  business_days = 0
	  date = date2
	  while date > date1
	     business_days = business_days + 1 unless date.saturday? or date.sunday?
	     date = date - 1.day
	  end
	  business_days
	end

	def weekdays(finalDay)
		list = []
		for i in 1..finalDay
			list << weekday(Date.strptime(@report.month.to_s+"/"+i.to_s+"/2018", '%m/%d/%Y'))
		end
		list
	end

	def weekday(date)
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