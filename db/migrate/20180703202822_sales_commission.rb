class SalesCommission < ActiveRecord::Migration[5.1]
  def change
    create_table :sales_commissions do |t|
      t.string :individual_goal,       null: false, default: ''
      t.string :individual_commission, null: false, default: 0
      t.string :team_goal,             null: false, default: ''
      t.string :team_commission,       null: false, default: 0

      t.timestamps
    end
  end
end
