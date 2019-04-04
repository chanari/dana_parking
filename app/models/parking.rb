class Parking < ApplicationRecord
  has_many :parking_slots, dependent: :destroy
  accepts_nested_attributes_for :parking_slots, reject_if: :all_blank
end
