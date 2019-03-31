class User < ApplicationRecord
  before_save :set_role
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_one :profile
  
  private

  def set_role
    self.role = '0' if self.role.nil?
  end
end
