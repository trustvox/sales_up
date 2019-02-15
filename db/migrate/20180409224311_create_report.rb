class CreateReport < ActiveRecord::Migration[5.1]
  def change
    create_table :reports do |t|
      t.string :report_name, null: false, default: ''
      t.decimal :goal,       null: false, default: 0
      t.string :month,       null: false, default: ''
      t.integer :year,       null: false, default: 0
      t.integer :month_number, null: false, default: 0

      t.timestamps
    end
  end
end
