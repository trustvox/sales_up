class RemoveValueAndAddReferenceFromUserInMeeting < ActiveRecord::Migration[5.1]
  def change
    remove_column :meetings, :value
    add_reference :meetings, :user_sales, index: true
  end
end
