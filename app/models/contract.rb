class Contract < ApplicationRecord
  belongs_to :user
  belongs_to :report

  validates :value, presence: true, numericality: { only_integer: true }
  validates :store_name, presence: true
  validates :value, presence: true, numericality: true
end
