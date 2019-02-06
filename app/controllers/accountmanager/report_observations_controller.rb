module Accountmanager
  class ReportObservationsController < ApplicationController
    def create
      obs = ReportObservation.new(report_obs_params)
      obs.save!
      redirect_to_report(obs.report_id)
    end

    def update
      obs = ReportObservation.find_by(id: params[:id])
      obs.update(report_obs_params)
      obs.observation == '' ? destroy : redirect_to_report(obs.report_id)
    end

    def destroy
      obs = ReportObservation.find_by(id: params[:id])
      obs.destroy
      redirect_to_report(obs.report_id)
    end

    private

    def redirect_to_report(report_id)
      report = fetch_report_by_id(report_id)
      side = params[:report_observation][:side]

      redirect_to controller: side + '/dashboard', action: 'report_' + side,
                  'report[month]' => report.month, 'report[year]' => report.year
    end

    def report_obs_params
      params.require(:report_observation).permit(:observation, :user_id,
                                                 :report_id)
    end
  end
end
