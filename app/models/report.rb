class Report < ApplicationRecord
  validates :report_name, length: { minimum: 20 }, presence: true
  validates :goal, presence: true, numericality: true
  validates :month_numb, inclusion: { in: (1..12) },
                         presence: true, numericality: { only_integer: true }
  validates :month, presence: true, inclusion: {
    in: (1..12).map { |m| Date::MONTHNAMES[m] },
    message: 'Month not valid'
  }
end
