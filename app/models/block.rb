class Block < ApplicationRecord
  belongs_to :floor
  has_many :parking_slots, dependent: :destroy

  accepts_nested_attributes_for :parking_slots, reject_if: :all_blank

  attr_accessor :slots

end
