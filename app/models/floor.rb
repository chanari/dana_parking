class Floor < ApplicationRecord
  belongs_to :parking
  has_many :blocks, dependent: :destroy

  accepts_nested_attributes_for :blocks, reject_if: :all_blank

end
