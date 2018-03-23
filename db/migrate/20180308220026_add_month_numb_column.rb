# AddMonthNumbColumn is responsible to include a new column in Report record
#   called month_numb with a integer format
class AddMonthNumbColumn < ActiveRecord::Migration[5.1]
  def change
    add_column :reports, :month_numb, :integer
  end
end
