class Ability
  include CanCan::Ability

  def initialize(user)
    authorize_user(user) if user.present?
  end

  def authorize_user(user)
    if user.priority >= 1
      can [:spreadsheet], HomeController

      if user.priority == 2
        can :manage, ManagementController
      else
        can %i[view manager add_contract
               alter_contract search_contract], ManagementController
      end
    end
    can %i[graphic search], HomeController
  end
end
