# ChangeGoalFormatInReport is responsible to change the goal format to
#   a decimal in Report Record
class ChangeGoalFormatInReport < ActiveRecord::Migration[5.1]
  def change
    change_column :reports, :goal, :decimal
  end
end
