class Ability
  include CanCan::Ability

  def initialize(user)
    user = User.new if user.nil?
    user.admin? || user.overall_manager? ? can(:manage, :all) : authorize(user)
  end

  def authorize(user)
    authorize_am(user) if user.am?
    authorize_sdr(user) if user.sdr?

    authorize_spector(user)
  end

  def authorize_am(_user)
    can :manage, AccountManager::ReportObservationsController
    can :manage, AccountManager::ContractsController
    can :manage, SalesRepresentative::MeetingsController
  end

  def authorize_sdr(_user)
    can :manage, SalesRepresentative::MeetingsController
  end

  def authorize_spector(_user)
    can %i[monthly_sales report_am overview_months_am overview_reports_am],
        AccountManager::DashboardController
    can %i[monthly_schedules overview_months_sdr overview_reports_sdr report_sdr],
        SalesRepresentative::DashboardController
  end
end
