class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # attr_accessor :login

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def admin?
    sub_area == 'admin'
  end

  def manager?
    sub_area == 'gg'
  end

  def overall_manager?
    area == 'gg'
  end

  def regular?
    priority == 1
  end

  def sales?
    area == 'sales'
  end

  def am?
    sub_area == 'am'
  end

  def sdr?
    sub_area == 'sdr'
  end

  def spectator?
    sub_area == 'spec'
  end

  def fn?
    sub_area == 'fn'
  end

  def ra?
    sub_area == 'ra'
  end
end
