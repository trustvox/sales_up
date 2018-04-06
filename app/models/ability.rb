class Ability
  include CanCan::Ability

  def initialize(user)
    logedin = user.present?
    (user.priority == 3 ? can(:manage, :all) : authorize_user(user)) if logedin
  end

  def authorize_user(user)
    if user.priority >= 1
      can :manage, ManagementController if user.priority == 2
      can %i[add_contract_data alter_contract_data], HomeController
    end
    can %i[graphic search spreadsheet], HomeController
  end
end
