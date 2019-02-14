module AccountManager
  class RecordDataController < AccountManager::OverviewController
    include RecordDataPoints

    before_action :init_record_data_points, only: [:fetch_record_data_points]
    before_action :authenticate_user!

    def init_record_data_points
      @record_data = []
      @record_point = []
    end

    private

    def fetch_record_data_points
      @record_data = fetch_record_data
      @record_point = fetch_record_points

      @record_point.each_with_index do |record, i|
        @record_point[i] = [[1, 0], [fetch_last_day, 0]] if record.blank?
      end
    end
  end
end
