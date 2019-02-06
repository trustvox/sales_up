class AddColumnScheduledRaiseIntoReport < ActiveRecord::Migration[5.1]
  def change
    add_column :reports, :scheduled_raise, :integer
    change_column_default(:reports, :scheduled_raise, 0)
  end
end
