class CreateReports < ActiveRecord::Migration[5.1]
  def change
    create_table :reports do |t|
    	t.string  :report_name, null: false, default: ""
    	t.integer :goal,        null: false, default: 0
    	t.integer :month,       null: false, default: 0
    	t.integer :year,        null: false, default: 0

      t.timestamps
    end
  end
end
