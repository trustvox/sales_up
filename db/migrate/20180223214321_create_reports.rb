# CreateReports is responsible to add a new record called Report
#   which will store the report_name, goal, month and year of a report
class CreateReports < ActiveRecord::Migration[5.1]
  def change
    create_table :reports do |t|
      t.string :report_name, null: false, default: ''
      t.integer :goal,        null: false, default: 0
      t.integer :month,       null: false, default: 0
      t.integer :year,        null: false, default: 0

      t.timestamps
    end
  end
end
