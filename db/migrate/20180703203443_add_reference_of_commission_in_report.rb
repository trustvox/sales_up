class AddReferenceOfCommissionInReport < ActiveRecord::Migration[5.1]
  def change
    add_reference :reports, :sales_commission, index: true
  end
end
