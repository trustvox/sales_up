# frozen_string_literal: true

class Contract < ApplicationRecord
  belongs_to :user
  belongs_to :report
end
