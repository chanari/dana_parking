class User < ApplicationRecord
  before_save :set_role
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_one :profile, dependent: :destroy
  has_one_attached :avatar

  def is_client?
    return self.role == '0'
  end

  private

  def set_role
    self.role = '0' if self.role.nil?
  end
end
