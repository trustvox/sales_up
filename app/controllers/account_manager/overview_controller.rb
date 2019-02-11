module AccountManager
  class OverviewController < ApplicationController
    include OverviewPoints
    include OverviewHelper

    def search_overview_months(type)
      init_overview_search_months(type)

      start_overview_search(type)
      overview_data('m', type)
    end

    def search_overview_reports(type)
      init_overview_search_reports(type)

      start_overview_search(type)
      @AM_points = overview_data('r', type)
    end

    private

    def init_overview_search_months(type)
      @goal_points = []
      @sum_points = []

      init_overview_search_bar(type)
    end

    def init_overview_search_reports(type)
      params[:report].nil? ? default_search(type) : custom_search(type)

      @AM_points = []
      init_overview_search_bar(type)
    end

    def init_overview_search_bar(type)
      @first_list = all_date_list(type)
      @last_list = all_date_list(type)

      if type == 'AM'
        remove_previous_months_first(type)
        remove_previous_months_last(type)
      end
      params[:report].nil? ? fetch_first_list : fecth_normal_list(type)

      @first_report = nil
      @last_report = nil
    end

    def start_overview_search(type)
      return init_overview_data(type, nil, nil) if params[:report].nil?
      init_overview_data(type, params[:report][:month].split('/'),
                         params[:report][:year].split('/'))
    end

    def default_search(type)
      @users = fetch_user_by_sub_area(type)
      @usernames = fetch_username_by_sub_area(type)
      if type == 'AM'
        @filter = 'CS'
        @simbol = t('graphic.currency') + ' %y.2'
      else
        @filter = 'MS'
        @simbol = '%y ' + t('graphic.meeting')
      end
    end

    def custom_search(type)
      @filter = params[:report][:goal]
      if params[:report][:report_name] == 'All'
        start_default_values(type)
      else
        start_custom_values
      end

      set_simbol_with_filter
    end

    def set_simbol_with_filter
      @simbol = case @filter
                when 'CS'
                  t('graphic.currency') + ' %y.2'
                when 'CC'
                  '%y ' + t('graphic.contract')
                when 'MS'
                  '%y ' + t('graphic.meeting')
                else
                  '%y.2%'
                end
    end

    def start_default_values(type)
      @usernames = fetch_username_by_sub_area(type)
      @users = fetch_user_by_sub_area(type)
    end

    def start_custom_values
      @usernames = [params[:report][:report_name]]
      @users = fetch_user_by_username(params[:report][:report_name])
    end
  end
end
