# DropUser is responsible to remove the record called User from the database
class DropUser < ActiveRecord::Migration[5.1]
  def change
    drop_table :users
  end
end
