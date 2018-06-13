class Ability
  include CanCan::Ability

  def initialize(user)
    (user.admin? ? can(:manage, :all) : authorize_user(user)) if user.present?
  end

  def authorize_user(user)
    if user.above_spectator?
      can :update, ContractsController
      can :create, ContractsController

      if user.manager?
        can :destroy, ContractsController
        can :manager, DashboardController
        can :manage, ReportsController
      end
    end
    can %i[monthly_sales search report_sales overview], DashboardController
  end
end
