class ChangeSalesmanNameToMeetingForInMeeting < ActiveRecord::Migration[5.1]
  def change
    rename_column :meetings, :salesman_name, :meeting_for
  end
end
