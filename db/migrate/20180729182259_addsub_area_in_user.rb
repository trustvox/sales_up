class AddsubAreaInUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :sub_area, :string
    change_column_default(:users, :sub_area, "")
  end
end
