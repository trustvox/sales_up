class Ability
  include CanCan::Ability

  def initialize(user)
    (user.admin? ? can(:manage, :all) : authorize_user(user)) if user.present?
  end

  def authorize_user(user)
    if user.above_spectator?
      can :manage, ManagementController if user.manager? == 2
      can %i[add_contract_data alter_contract_data], HomeController
    end
    can %i[graphic search spreadsheet overview], HomeController
  end
end
