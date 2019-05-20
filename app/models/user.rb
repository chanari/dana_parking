class User < ApplicationRecord
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: 'Email sai' }

  before_save :set_role
  has_many :parking_slot_reservations
  has_many :vehicles, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_one :profile, dependent: :destroy
  has_one_attached :avatar

  def is_client?
    return self.role == '0'
  end

  def is_manager?
    return self.role == '1'
  end

  def is_admin?
    return self.role == '2'
  end

  def get_parking
    Parking.select(:id, :address).where(id: self.parking_id).take()
  end

  private

  def set_role
    self.role = '0' if self.role.nil?
  end
end
