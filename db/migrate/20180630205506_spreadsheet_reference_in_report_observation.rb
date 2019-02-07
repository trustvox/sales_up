class SpreadsheetReferenceInReportObservation < ActiveRecord::Migration[5.1]
  def change
    add_reference :report_observations, :report, index: true
  end
end
