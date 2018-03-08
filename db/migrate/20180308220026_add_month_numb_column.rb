class AddMonthNumbColumn < ActiveRecord::Migration[5.1]
  def change
  	add_column :reports, :month_numb, :integer
  end
end
