class RemovePriorityColumn < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :priority
  end
end
