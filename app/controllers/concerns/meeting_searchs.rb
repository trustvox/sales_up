module MeetingSearchs
  def fetch_meeting_by_report_id(report_id)
    Meeting.where(report_id: report_id).order('day')
  end

  def fetch_meetings_by_day_report_id(day, report_id)
    Meeting.where(day: day, report_id: report_id)
  end

  def fetch_meeting_sum(user_id, report_id, day = 0)
    fetch_scheduled_meeting(user_id, report_id, day).count
  end

  def fetch_unique_days_meeting(user_id, report_id)
    fetch_scheduled_meeting(user_id, report_id).distinct.pluck(:day)
  end

  def fetch_scheduled_meeting(user_id, report_id, day = 0)
    if day.zero?
      return Meeting.where(user_id: user_id, report_id: report_id).order('day')
    end
    Meeting.where(day: day, user_id: user_id, report_id: report_id).order('day')
  end

  def fetch_meetings(day, report_id, user_id)
    Meeting.where(day: day, report_id: report_id, user_id: user_id)
  end
end
