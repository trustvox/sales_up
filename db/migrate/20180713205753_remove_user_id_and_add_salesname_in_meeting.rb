class RemoveUserIdAndAddSalesnameInMeeting < ActiveRecord::Migration[5.1]
  def change
    remove_column :meetings, :user_sales_id
    add_column :meetings, :salesman_name, :string
    change_column_default(:meetings, :salesman_name, "")
  end
end
