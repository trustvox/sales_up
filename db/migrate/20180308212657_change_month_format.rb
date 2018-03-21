# ChangeMonthFormat is responsible to change the month format to a string
#   in Report record
class ChangeMonthFormat < ActiveRecord::Migration[5.1]
  def change
    change_column :reports, :month, :string
  end
end
