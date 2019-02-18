module AccountManager
  class ReportObservationsController < ApplicationController
    def create
      @observation = ReportObservation.new(report_observation_params)
      @observation.save!

      redirect_to_report
    end

    def update
      @observation = ReportObservation.find_by(id: params[:id])
      @observation.update(report_observation_params)

      @observation.observation == '' ? destroy : redirect_to_report
    end

    def destroy
      @observation = ReportObservation.find_by(id: params[:id])
      @observation.destroy

      redirect_to_report
    end

    private

    def redirect_to_report
      report = fetch_report_by_id(@observation.report_id)
      side = params[:report_observation][:side].split('/')

      redirect_to controller: side[0] + '/dashboard',
                  action: 'report_' + side[1],
                  'report[month]' => report.month,
                  'report[year]' => report.year
    end

    def report_observation_params
      params.require(:report_observation).permit(:observation, :user_id,
                                                 :report_id)
    end
  end
end
