class AddPriorityColumn < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :priority, :integer
  end
end
