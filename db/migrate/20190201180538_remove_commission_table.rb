class RemoveCommissionTable < ActiveRecord::Migration[5.1]
  def change
  	drop_table :sales_commissions
  end
end
