class RemoveNilFromTypeInUser < ActiveRecord::Migration[5.1]
  def change
    change_column_default(:users, :type, "")
  end
end
