module UserSearchs
  def fetch_user_by_id(user_id)
    User.find_by(id: user_id)
  end

  def fetch_username_by_id(user_id)
    User.find_by(id: user_id).full_name
  end

  def fetch_user_by_username(full_name)
    User.where(full_name: full_name)
  end

  def fetch_id_by_username(full_name)
    User.find_by(full_name: full_name).id
  end

  def fetch_username_by_types(sub_area1, sub_area2)
    User.where('sub_area = ? OR sub_area = ?', sub_area1, sub_area2)
                    .order('full_name')
  end

  def fetch_user_by_area(type)
    User.where(area: type).order('full_name')
  end

  def fetch_user_by_sub_area(type)
    User.where(sub_area: type).order('full_name')
  end

  def fetch_username_by_area(type)
    fetch_user_by_area(type).collect(&:full_name)
  end

  def fetch_username_by_sub_area(type)
    fetch_user_by_sub_area(type).collect(&:full_name)
  end

  def fetch_user_by_email(email)
    User.find_by(email: email)
  end

  def fetch_user_by_individual_goal(report_id)
    user_ids = fetch_user_by_individual_goal_with_id(report_id)
    user_ids.collect { |user_id| fetch_user_by_id(user_id) }
  end

  def fetch_user_observation(username)
    ReportObservation.where(user_id: fetch_id_by_username(username),
                            report_id: @current_report.id)[0]
  rescue StandardError
    nil
  end
end
