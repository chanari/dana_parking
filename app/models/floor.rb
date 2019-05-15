class Floor < ApplicationRecord
  belongs_to :parking
  has_many :blocks, dependent: :destroy

  accepts_nested_attributes_for :blocks, allow_destroy: true, reject_if: :all_blank

  scope :get_floors, -> (park_id, size) { select(:id, :name, :price_by_hours, :price_by_months).where(parking_id: park_id, size: size) }

end
