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
  end
end
