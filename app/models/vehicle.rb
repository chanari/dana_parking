class Vehicle < ApplicationRecord
  belongs_to :user

  validates :number_plate, uniqueness: { case_sensitive: false, scope: :user_id }
end
