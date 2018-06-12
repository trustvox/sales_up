class Contract < ApplicationRecord
  belongs_to :user
  belongs_to :report

  validates :value, presence: true, numericality: true
  validates :store_name, presence: true
end
