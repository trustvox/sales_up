class RemoveNilFromObservationInReport < ActiveRecord::Migration[5.1]
  def change
    change_column_default(:reports, :observation, "")
  end
end