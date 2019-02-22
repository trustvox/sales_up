module AccountManager
  class RecordDataController < AccountManager::OverviewController
    include RecordDataPoints

    before_action :init_record_data_points, only: [:fetch_record_data_points]
    before_action :authenticate_user!

    def init_record_data_points
      @record_data = []
      @record_point = []
    end

    def fetch_record_data_points
      @record_data = fetch_record_data
      @record_point = fetch_record_points

      @record_point.each_with_index do |record, i|
        @record_point[i] = [[1, 0], [fetch_last_day, 0]] if record.blank?
      end
    end

    def fetch_record_data
      fetch_user_by_individual_goal(@current_report.id).collect do |user|
        next fetch_empty_data_array(user) if verify_fetched_data(user.id)

        fetch_record_days(user.id)

        create_data_array(user, fetch_gap, fetch_record_sum(user.id))
      end
    end

    def fetch_record_points
      fetch_user_by_individual_goal(@current_report.id).collect do |user|
        next if verify_fetched_points(user.id)

        @list = []
        @sum = 0

        @gap = calculate_delta_gap
        organize_data(user.id) unless @unique_days.empty?

        @list
      end
    end

    def fetch_empty_data_array(user)
      type_am? ? [user.full_name, 0, 0, 0, 0, 0] : [user.full_name, 0, 0, 0, 0]
    end

    def verify_fetched_data(user_id)
      if type_am?
        return fetch_closed_contracts(user_id, @current_report.id).empty?
      end

      fetch_scheduled_meeting(user_id, @current_report.id).empty?
    end

    def verify_fetched_points(user_id)
      fetch_record_days(user_id)
      @unique_days.empty?
    end
  end
end
