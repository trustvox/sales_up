class TokenPassword < ApplicationRecord
  belongs_to :user

  validates :token, presence: true, uniqueness: true
  validates :used, presence: true, length: { minimum: 1, maximum: 3 },
                   inclusion: { in: %w[yes no] }
end
