class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # attr_accessor :login

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def admin?
    priority == 3
  end

  def manager?
    priority == 2
  end

  def regular?
    priority == 1
  end

  def spectator?
    priority.zero?
  end

  def above_spectator?
    priority.positive?
  end

  def new_user?
    priority < 0
  end
end
