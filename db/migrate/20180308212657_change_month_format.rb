class ChangeMonthFormat < ActiveRecord::Migration[5.1]
  def change
  	change_column :reports, :month, :string
  end
end
