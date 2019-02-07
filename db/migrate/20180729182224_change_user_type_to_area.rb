class ChangeUserTypeToArea < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :priority_type, :area
  end
end
