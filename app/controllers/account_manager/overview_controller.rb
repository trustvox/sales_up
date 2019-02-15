module AccountManager
  class OverviewController < ApplicationController
    include OverviewPoints

    def search_overview_months(type)
      @goal_points = []
      @am_points = []

      start_overview_search('m', type)
    end

    def search_overview_reports(type)
      @am_points = start_overview_search('r', type)
    end

    private

    def start_overview_search(which, type)
      return overview_data(which, type) if params[:report].nil?

      overview_data(which, type, params[:report][:month].split('/'),
                    params[:report][:year].split('/'))
    end
  end
end
