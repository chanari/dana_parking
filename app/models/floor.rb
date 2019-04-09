class Floor < ApplicationRecord
  belongs_to :parking
  has_many :blocks, dependent: :destroy

  accepts_nested_attributes_for :blocks, reject_if: :all_blank

  scope :get_floors, -> (park_id, size) { where(parking_id: park_id, size: size) }

end
