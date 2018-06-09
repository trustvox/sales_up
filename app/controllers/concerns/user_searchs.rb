module UserSearchs
  def fetch_username_by_id(user_id)
    User.find_by(id: user_id).full_name
  end

  def fetch_user_by_username(full_name)
    User.where(full_name: full_name)
  end

  def fetch_id_by_username(full_name)
    User.find_by(full_name: full_name).id
  end

  def fetch_username_by_priority
    User.where('priority BETWEEN ? AND ?', 1, 2).order('full_name')
  end

  def fetch_user_by_priority(priority)
    User.where(priority: priority).order('full_name')
  end

  def fetch_username_by_salesman_priority
    fetch_user_by_priority(1).collect(&:full_name)
  end
end
