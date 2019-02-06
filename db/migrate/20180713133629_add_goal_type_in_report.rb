class AddGoalTypeInReport < ActiveRecord::Migration[5.1]
  def change
    add_column :reports, :goal_type, :string
    change_column_default(:reports, :goal_type, "")
  end
end
