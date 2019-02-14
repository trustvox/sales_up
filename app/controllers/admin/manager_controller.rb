module Admin
  class ManagerController < ApplicationController
    before_action :init_manager_data, only: [:manager_settings]
    before_action only: [:manage_new_user] do
      verify_priority_and_type(params[:user][:id],
                               params[:user][:priority].to_i,
                               params[:user][:priority_type])
    end
    before_action :authenticate_user!

    def manager_settings
      @page_title = init_page_title(params[:report][:side])
      render_menu(@page_title[2])
    end

    def manage_new_user
      redirect_to controller: 'manager', action: 'manager_settings',
                  'report[year]' => fetch_last_year,
                  'report[side]' => params[:user][:side]
    end

    private

    def verify_priority_and_type(user_id, new_priority, new_priority_type)
      user = fetch_user_by_id(user_id)
      return user.destroy if new_priority.negative?

      user.priority = new_priority
      user.priority_type = new_priority.zero? ? 'spec' : new_priority_type
      user.save

      send_out_message(user.email)
    end

    def send_out_message(email)
      zapper = ZapierRuby::Zapper.new(:email_zap)
      zapper.zap(json_maker(email, 'Account permission allowed',
                            'Your account have been aproved: ' +
                            ENV['link_to_root']))
    end

    def init_manager_data
      verify_authorization(action_name.parameterize.underscore.to_sym,
                           Admin::ManagerController)

      @spreadsheets = []
      @unique_years = []

      fetch_manager_data

      @report = Report.new
    end

    def fetch_manager_data
      report_year = params[:report][:years]
      year = report_year[0...-1].split('/') unless report_year.nil?

      %w[AM SDR].each_with_index do |data, i|
        add_manager_data(
          data, report_year.nil? ? fetch_last_year_with_type(data) : year[i]
        )
      end
    end

    def add_manager_data(data, year)
      @spreadsheets << [data] + fetch_reports_by_year(year, data)
      @unique_years << fetch_report_by_unique_years(data, year.to_i)
    end
  end
end
