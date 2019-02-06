class Contract < ApplicationRecord
  belongs_to :user
  belongs_to :report

  validates :day, presence: true, numericality: true
  validates :value, presence: true, numericality: true
  validates :store_name, presence: true
end
