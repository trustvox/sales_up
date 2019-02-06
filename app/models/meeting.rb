class Meeting < ApplicationRecord
  belongs_to :user
  belongs_to :report

  validates :day, presence: true, numericality: true
  validates :client_name, presence: true
  validates :scheduled_for, presence: true
  validates :meeting_for, presence: true
end
