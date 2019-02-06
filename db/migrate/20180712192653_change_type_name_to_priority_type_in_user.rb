class ChangeTypeNameToPriorityTypeInUser < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :type, :priority_type
  end
end
