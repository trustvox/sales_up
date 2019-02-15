class Report < ApplicationRecord
  validates :report_name, presence: true
  validates :goal, presence: true, numericality: true
  validates :month_number, inclusion: { in: (1..12) },
                         presence: true, numericality: { only_integer: true }
  validates :year, presence: true, numericality: true
  validates :month, presence: true, inclusion: {
    in: (1..12).map { |m| Date::MONTHNAMES[m] },
    message: 'Month not valid'
  }
end
