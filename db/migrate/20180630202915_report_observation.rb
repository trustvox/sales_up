class ReportObservation < ActiveRecord::Migration[5.1]
  def change
    create_table :report_observations do |t|
      t.string :observation
      t.string :part_number
    end

    add_reference :report_observations, :user, index: true
  end
end
