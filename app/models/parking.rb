class Parking < ApplicationRecord
  has_many :floors, dependent: :destroy

  accepts_nested_attributes_for :floors, reject_if: :all_blank
end
