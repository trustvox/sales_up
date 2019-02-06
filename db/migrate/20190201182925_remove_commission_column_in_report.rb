class RemoveCommissionColumnInReport < ActiveRecord::Migration[5.1]
  def change
  	remove_column :reports, :sales_commission_id
  end
end
