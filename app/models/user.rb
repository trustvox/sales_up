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
    sub_area == 'GG'
  end

  def overall_manager?
    area == 'GG'
  end

  def regular?
    priority == 1
  end

  def sales?
    area == 'sales'
  end

  def AM?
    sub_area == 'AM'
  end

  def SDR?
    sub_area == 'SDR'
  end

  def spectator?
    sub_area == 'spec'
  end

  def FN?
    sub_area == 'FN'
  end

  def RA?
    sub_area == 'RA'
  end
end
