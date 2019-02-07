class ChangeScheduledRaiseFormatToFloat < ActiveRecord::Migration[5.1]
  def change
    change_column :reports, :scheduled_raise, :float
  end
end
