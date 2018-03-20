class CreateContracts < ActiveRecord::Migration[5.1]
  def change
    create_table :contracts do |t|
      t.integer :day, null: false, default: 0
      t.string  :store_name, null: false, default: 0
      t.decimal :value,      null: false, default: 0

      t.timestamps
    end
  end
end
