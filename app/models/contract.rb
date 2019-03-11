class Contract < ApplicationRecord
  belongs_to :user
  belongs_to :report

  validates :day, presence: true, numericality: true, 
            inclusion: { in: :month_days_of_report }
  validates :value, presence: true, numericality: true
  validates :store_name, presence: true, length: { in: 2..100 }

  def month_days_of_report
  	(1..last_day_of_month)
  end

  def last_day_of_month
  	Time.days_in_month(report_record.month_number)
  end

  def report_record
  	Report.find_by(id: report_id)
  end
end
