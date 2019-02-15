module Admin
  class ManagerController < ApplicationController
    before_action :init_manager_data, only: [:manager_settings]

    before_action :authenticate_user!

    def manager_settings
      render_menu(params[:report][:side])
    end

    def manage_new_user
      redirect_to controller: 'manager', action: 'manager_settings',
                  'report[year]' => fetch_last_year,
                  'report[side]' => params[:user][:side]
    end

    private

    def init_manager_data
      verify_authorization(Admin::ManagerController)

      @spreadsheets = []
      @unique_years = []

      fetch_manager_data

      @report = Report.new
    end

    def fetch_manager_data
      report_year = params[:report][:years]
      year = report_year[0...-1].split('/') unless report_year.nil?

      %w[am sdr].each_with_index do |data, i|
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
