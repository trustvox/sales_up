class AddIndividualGoalIntoReport < ActiveRecord::Migration[5.1]
  def change
    add_column :reports, :individual_goal, :string
    change_column_default(:reports, :individual_goal, "")
  end
end
